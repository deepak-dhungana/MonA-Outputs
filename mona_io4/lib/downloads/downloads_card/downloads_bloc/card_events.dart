part of 'card_bloc.dart';

abstract class DCardEvent extends Equatable {
  const DCardEvent();

  @override
  List<Object?> get props => [];
}

// ############################################################################

class DCardPermissionRequested extends DCardEvent {
  const DCardPermissionRequested();

  @override
  String toString() => "DCardPermissionGranted Event";
}

class DCardDownloadProgressed extends DCardEvent {
  final double progress;

  const DCardDownloadProgressed({required this.progress});

  @override
  String toString() =>
      "DCardDownloadProgressed Event: Progress $progress";

  @override
  List<Object?> get props => [progress];
}

class DCardDownloadCompleted extends DCardEvent {
  const DCardDownloadCompleted();

  @override
  String toString() => "DCardDownloadCompleted Event";
}

class DCardDownloadFailed extends DCardEvent {
  const DCardDownloadFailed();

  @override
  String toString() => "DCardDownloadFailed  Event";
}

class DCardGoBackToInitial extends DCardEvent {
  const DCardGoBackToInitial();

  @override
  String toString() => "DCardGoBackToInitial  Event";
}
