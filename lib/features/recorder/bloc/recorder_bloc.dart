import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_recorder_/features/recorder/data/recorder_repository.dart';
import 'recorder_event.dart';
import 'recorder_state.dart';

class RecorderBloc extends Bloc<RecorderEvent, RecorderState> {
  final RecorderRepository _repository = RecorderRepository();
  Timer? _timer;
  Duration _duration = Duration.zero;

  RecorderBloc() : super(RecordInitial()) {
    on<StartRecordingEvent>(_onStartRecording);
    on<PauseRecordingEvent>(_onPauseRecording);
    on<ResumeRecordingEvent>(_onResumeRecording);
    on<StopRecordingEvent>(_onStopRecording);
    on<UploadRecordingEvent>(_onUploadRecording);
    on<TickEvent>(_onTick);
    on<ResetEvent>(_onReset);
  }

  Future<void> _onStartRecording(
    StartRecordingEvent event,
    Emitter<RecorderState> emit,
  ) async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.storage,
        Permission.photos, 
      ].request();

      if (statuses[Permission.microphone]!.isDenied) {
        emit(
          const RecordFailure(
            error: 'Microphone permission denied! Cannot record audio.',
          ),
        );
        return;
      }

      final String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}';

      bool started = await FlutterScreenRecording.startRecordScreenAndAudio(
        fileName,
      );

      if (started) {
        _duration = Duration.zero;
        _startTimer();
        emit(RecordingInProgress(duration: _duration));
      } else {
        emit(
          const RecordFailure(
            error: 'Failed to start recording! Is the app installed properly?',
          ),
        );
      }
    } catch (e) {
      emit(RecordFailure(error: e.toString()));
    }
  }

  Future<void> _onUploadRecording(
    UploadRecordingEvent event,
    Emitter<RecorderState> emit,
  ) async {
    try {
      emit(const UploadingInProgress(progress: 0));
      await _repository.uploadRecording(
        event.path,
        event.durationSeconds,
        onProgress: (progress) {},
      );
      emit(const UploadSuccess(message: 'Recording uploaded successfully!'));
    } catch (e) {
      emit(
        RecordFailure(
          error: e.toString(),
          isUploadError: true,
          path: event.path,
          durationSeconds: event.durationSeconds,
        ),
      );
    }
  }

  Future<void> _onPauseRecording(
    PauseRecordingEvent event,
    Emitter<RecorderState> emit,
  ) async {
    _stopTimer();
    emit(RecordingPaused(duration: _duration));
  }

  Future<void> _onResumeRecording(
    ResumeRecordingEvent event,
    Emitter<RecorderState> emit,
  ) async {
    _startTimer();
    emit(RecordingInProgress(duration: _duration));
  }

  Future<void> _onStopRecording(
    StopRecordingEvent event,
    Emitter<RecorderState> emit,
  ) async {
    try {
      _stopTimer();
      String finalPath = await FlutterScreenRecording.stopRecordScreen;

      final box = Hive.box('recordings');
      await box.add({
        'path': finalPath,
        'date': DateTime.now().toIso8601String(),
        'durationSeconds': _duration.inSeconds,
      });

      emit(
        RecordingStopped(path: finalPath, durationSeconds: _duration.inSeconds),
      );

      add(ResetEvent());
    } catch (e) {
      emit(RecordFailure(error: e.toString()));
    }
  }

  void _onTick(TickEvent event, Emitter<RecorderState> emit) {
    if (state is RecordingInProgress) {
      _duration = event.duration;
      emit(RecordingInProgress(duration: _duration));
    }
  }

  void _onReset(ResetEvent event, Emitter<RecorderState> emit) {
    emit(RecordInitial());
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TickEvent(_duration + const Duration(seconds: 1)));
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
