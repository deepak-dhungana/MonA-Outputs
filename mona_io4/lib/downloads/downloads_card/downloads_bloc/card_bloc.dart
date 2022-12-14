import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mona/downloads/downloads_logic/downloads_logic.dart';
import 'package:permission_handler/permission_handler.dart';

part 'card_events.dart';

part 'card_states.dart';

class DCardBloc extends Bloc<DCardEvent, DCardState> {
  final MonAPDFFile pdfFile;

  DCardBloc({required this.pdfFile}) : super(const DCardInitial()) {
    on<DCardPermissionRequested>(_onPermissionRequested);
    on<DCardDownloadProgressed>(_onDownloadProgressed);
    on<DCardDownloadCompleted>(_onDownloadCompleted);
    on<DCardDownloadFailed>(_onDownloadFailed);
    on<DCardGoBackToInitial>(_onGoBackToInitial);
  }

  /// On file download progress
  void _onDownloadProgress(double progress) async {
    add(DCardDownloadProgressed(progress: progress));
  }

  void _onPermissionRequested(
      DCardPermissionRequested event, Emitter<DCardState> emit) async {
    if (!kIsWeb) {
      emit(const DCardDownloadConfiguring());

      PermissionStatus storagePermission = await Permission.storage.request();

      if (storagePermission.isGranted) {
        DownloadsUtil.downloadFileNonWeb(
            fileName: pdfFile.fileName,
            ftpLocation: pdfFile.ftpLocation,
            onDownloadProgress: _onDownloadProgress);
      } else if (storagePermission.isPermanentlyDenied) {
        emit(const DCardInitial());
        openAppSettings();
      } else {
        emit(const DCardInitial());
      }
    }
  }

  void _onDownloadProgressed(
      DCardDownloadProgressed event, Emitter<DCardState> emit) {
    if (event.progress < 1) {
      emit(DCardDownloadInProgress(progress: event.progress));
    } else {
      add(const DCardDownloadCompleted());
    }
  }

  void _onDownloadCompleted(
      DCardDownloadCompleted event, Emitter<DCardState> emit) {
    emit(const DCardDownloadSuccess());
    Future.delayed(const Duration(milliseconds: 1800), () {
      add(const DCardGoBackToInitial());
    });
  }

  void _onDownloadFailed(DCardDownloadFailed event, Emitter<DCardState> emit) {
    emit(const DCardDownloadFailure());
    Future.delayed(const Duration(milliseconds: 1800), () {
      add(const DCardGoBackToInitial());
    });
  }

  void _onGoBackToInitial(
      DCardGoBackToInitial event, Emitter<DCardState> emit) {
    emit(const DCardInitial());
  }
}
