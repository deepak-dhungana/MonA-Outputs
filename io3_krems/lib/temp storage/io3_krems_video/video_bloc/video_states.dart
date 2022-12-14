part of 'video_bloc.dart';

abstract class IO3KremsVideoState extends Equatable {
  const IO3KremsVideoState();

  @override
  List<Object?> get props => [];
}

// ############################################################################

class PermissionReqInProgress extends IO3KremsVideoState {
  const PermissionReqInProgress();

  @override
  String toString() {
    return "IO3Krems BLoC - State: PermissionReqInProgress";
  }
}

class ErrorState extends IO3KremsVideoState {
  final String errorMessage;

  const ErrorState(this.errorMessage);

  @override
  String toString() {
    return "IO3Krems BLoC - State: ErrorState";
  }
}

// ############################################################################

class IO3KremsVideoRecordingInit extends IO3KremsVideoState {
  const IO3KremsVideoRecordingInit();

  @override
  String toString() {
    return "IO3Krems BLoC - State: IO3KremsVideoRecordingInit";
  }
}

class IO3KremsVideoRecordingInProgress extends IO3KremsVideoState {

  final int elapsedTime;

  const IO3KremsVideoRecordingInProgress(this.elapsedTime);

  @override
  List<Object?> get props => [elapsedTime];

  @override
  String toString() {
    return "IO3Krems BLoC - State: IO3KremsVideoRecordingInProgress";
  }
}

class IO3KremsVideoRecordingComplete extends IO3KremsVideoState {

  final MonAVideoFile videoFile;

  const IO3KremsVideoRecordingComplete(this.videoFile);

  @override
  String toString() {
    return "IO3Krems BLoC - State: IO3KremsVideoRecordingComplete";
  }
}
