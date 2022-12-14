part of 'card_bloc.dart';

abstract class DCardState extends Equatable {
  const DCardState();

  @override
  List<Object?> get props => [];
}
// ############################################################################

class DCardInitial extends DCardState {
  const DCardInitial();

  @override
  String toString() => "DownloadCardInitial State";
}

class DCardDownloadInProgress extends DCardState {
  final double progress;

  const DCardDownloadInProgress({required this.progress});

  @override
  String toString() => "DCardDownloadInProgress State: Progress $progress";

  @override
  List<Object?> get props => [progress];
}

class DCardDownloadConfiguring extends DCardState {
  const DCardDownloadConfiguring();

  @override
  String toString() => "DCardDownloadConfiguring State";
}

class DCardDownloadSuccess extends DCardState {
  const DCardDownloadSuccess();

  @override
  String toString() => "DCardDownloadSuccess State";
}

class DCardDownloadFailure extends DCardState {
  const DCardDownloadFailure();

  @override
  String toString() => "DCardDownloadFailure State";
}
