import 'package:equatable/equatable.dart';

abstract class RecorderEvent extends Equatable {
  const RecorderEvent();

  @override
  List<Object?> get props => [];
}

class StartRecordingEvent extends RecorderEvent {
  final bool recordAudio;
  const StartRecordingEvent({this.recordAudio = true});

  @override
  List<Object?> get props => [recordAudio];
}

class PauseRecordingEvent extends RecorderEvent {}

class ResumeRecordingEvent extends RecorderEvent {}

class StopRecordingEvent extends RecorderEvent {}

class UploadRecordingEvent extends RecorderEvent {
  final String path;
  final int durationSeconds;
  
  const UploadRecordingEvent({
    required this.path, 
    required this.durationSeconds,
  });

  @override
  List<Object?> get props => [path, durationSeconds];
}

class TickEvent extends RecorderEvent {
  final Duration duration;
  const TickEvent(this.duration);

  @override
  List<Object?> get props => [duration];
}

class ResetEvent extends RecorderEvent {}
