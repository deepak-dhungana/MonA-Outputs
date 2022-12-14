import 'dart:async';
import 'dart:html' as html;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:io3_krems/io3_krems_video/video_logic/time_elapsed.dart';

import '../../mona_web_camera.dart';

part 'video_states.dart';

part 'video_events.dart';

class IO3KremsVideoBloc extends Bloc<IO3KremsVideoEvent, IO3KremsVideoState> {
  ///
  final MonAWebCameraService _cameraService =
      MonAWebCameraService(task: CameraTasks.recordVideo);

  ///
  final TimeTicker _ticker = const TimeTicker();
  StreamSubscription<int>? _timeElapsed;

  IO3KremsVideoBloc() : super(const PermissionReqInProgress()) {
    on<PermissionRequested>(_onPermissionRequested);
    on<PermissionGranted>(_onPermissionGranted);
    on<StartVideoRecording>(_onStartVideoRecording);
    on<TimeElapsed>(_onTimeElapsed);
    on<StopVideoRecording>(_onStopVideoRecording);
    on<DownloadVideo>(_onDownloadVideo);
    on<ResetState>(_onResetState);
  }

  @override
  Future<void> close() {
    _timeElapsed?.cancel();
    return super.close();
  }

  void _onPermissionRequested(
      PermissionRequested event, Emitter<IO3KremsVideoState> emit) async {
    _cameraService.initializeCamera()
      ..then((_) {
        add(PermissionGranted());
      })
      ..onError((error, stackTrace) {
        emit(const ErrorState(""));
      });
  }

  void _onPermissionGranted(
      PermissionGranted event, Emitter<IO3KremsVideoState> emit) async {
    await _cameraService.createCameraPreview().then((_) {
      emit(const IO3KremsVideoRecordingInit());
    });
  }

  void _onStartVideoRecording(
      StartVideoRecording event, Emitter<IO3KremsVideoState> emit) {
    emit(const IO3KremsVideoRecordingInProgress(0));

    _cameraService.startVideoRecording().then((_) {
      // cancel if the ticker already started
      _timeElapsed?.cancel();

      // initialize the ticker
      _timeElapsed = _ticker.tick().listen((int elapsedTime) {
        add(TimeElapsed(elapsedTime));
      });
    });
  }

  void _onTimeElapsed(TimeElapsed event, Emitter<IO3KremsVideoState> emit) {
    emit(IO3KremsVideoRecordingInProgress(event.elapsedTime));
  }

  void _onStopVideoRecording(
      StopVideoRecording event, Emitter<IO3KremsVideoState> emit) async {
    _timeElapsed?.cancel();

    await _cameraService.stopVideoRecording().then((MonAVideoFile video) {
      // _cameraService.downloadFile(blobURL: video.videoBlobURL, fileName: video.fileName);

      emit(IO3KremsVideoRecordingComplete(video));
    });
  }

  void _onDownloadVideo(DownloadVideo event, Emitter<IO3KremsVideoState> emit) {
    _cameraService.downloadFile(
        blobURL: event.videoFile.videoBlobURL,
        fileName: event.videoFile.fileName);
  }

  void _onResetState(ResetState event, Emitter<IO3KremsVideoState> emit) {
    html.window.location.replace("");
  }
}
