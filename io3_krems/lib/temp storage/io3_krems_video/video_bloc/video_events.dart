part of 'video_bloc.dart';

abstract class IO3KremsVideoEvent extends Equatable {
  const IO3KremsVideoEvent();

  @override
  List<Object?> get props => [];
}

// ############################################################################

class PermissionRequested extends IO3KremsVideoEvent {
  @override
  String toString() {
    return "IO3Krems BLoC - Event: PermissionRequested";
  }
}

class PermissionGranted extends IO3KremsVideoEvent {
  @override
  String toString() {
    return "IO3Krems BLoC - Event: PermissionGranted";
  }
}

class StartVideoRecording extends IO3KremsVideoEvent {
  @override
  String toString() {
    return "IO3Krems BLoC - Event: StartVideoRecording";
  }
}

class TimeElapsed extends IO3KremsVideoEvent {
  final int elapsedTime;

  const TimeElapsed(this.elapsedTime);

  @override
  String toString() {
    return "IO3Krems BLoC - Event: TimeElapsed";
  }

  @override
  List<Object?> get props => [elapsedTime];
}

class StopVideoRecording extends IO3KremsVideoEvent {
  @override
  String toString() {
    return "IO3Krems BLoC - Event: StopVideoRecording";
  }
}

class ErrorOccurred extends IO3KremsVideoEvent {
  final String errorMessage;

  const ErrorOccurred(this.errorMessage);

  @override
  String toString() {
    return "IO3Krems BLoC - Event: ErrorOccurred";
  }

  @override
  List<Object?> get props => [errorMessage];
}

class DownloadVideo extends IO3KremsVideoEvent {

  final MonAVideoFile videoFile;

  const DownloadVideo(this.videoFile);

  @override
  String toString() {
    return "IO3Krems BLoC - Event: StopVideoRecording";
  }
}

class ResetState extends IO3KremsVideoEvent {
  @override
  String toString() {
    return "IO3Krems BLoC - Event: ResetState";
  }
}