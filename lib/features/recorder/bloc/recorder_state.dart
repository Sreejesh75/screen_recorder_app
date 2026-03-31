import 'package:equatable/equatable.dart';

abstract class RecorderState extends Equatable {
  const RecorderState();

  @override
  List<Object?> get props => [];
}

class RecordInitial extends RecorderState {}

class RecordingInProgress extends RecorderState {
  final Duration duration;
  const RecordingInProgress({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class RecordingPaused extends RecorderState {
  final Duration duration;
  const RecordingPaused({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class RecordingStopped extends RecorderState {
  final String path;
  const RecordingStopped({required this.path});

  @override
  List<Object?> get props => [path];
}

class UploadingInProgress extends RecorderState {
  final double progress;
  const UploadingInProgress({required this.progress});

  @override
  List<Object?> get props => [progress];
}

class UploadSuccess extends RecorderState {
  final String message;
  const UploadSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class RecordFailure extends RecorderState {
  final String error;
  const RecordFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
