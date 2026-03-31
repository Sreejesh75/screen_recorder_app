import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_recorder_/core/theme/app_theme.dart';
import 'package:screen_recorder_/features/recorder/bloc/recorder_bloc.dart';
import 'package:screen_recorder_/features/recorder/bloc/recorder_event.dart';
import 'package:screen_recorder_/features/recorder/bloc/recorder_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_recorder_/features/recorder/presentation/widgets/control_button.dart';
import 'package:screen_recorder_/features/recorder/presentation/widgets/pulse_dot.dart';
import 'package:screen_recorder_/features/recorder/presentation/widgets/timer_display.dart';

class RecorderView extends StatelessWidget {
  const RecorderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecorderBloc, RecorderState>(
      listener: (context, state) {
        if (state is RecordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.redAccent),
          );
        }
        if (state is RecordingStopped) {
          _showSaveDialog(context, state.path);
        }
      },
      builder: (context, state) {
        Duration duration = Duration.zero;
        String status = "Ready to record";
        Color statusColor = Colors.white24;

        if (state is RecordingInProgress) {
          duration = state.duration;
          status = "Recording...";
          statusColor = Colors.redAccent;
        } else if (state is RecordingPaused) {
          duration = state.duration;
          status = "Paused";
          statusColor = Colors.orangeAccent;
        } else if (state is RecordingStopped) {
          status = "Stopped";
          statusColor = Colors.grey;
        } else if (state is UploadingInProgress) {
          status = "Uploading...";
          statusColor = AppTheme.accent;
        } else if (state is UploadSuccess) {
          status = "Uploaded";
          statusColor = Colors.greenAccent;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (state is UploadingInProgress)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(color: AppTheme.accent),
              )
            else
              TimerDisplay(duration: duration, color: statusColor),
            const SizedBox(height: 16),
            _buildStatusBadge(status, statusColor, state is RecordingInProgress),
            const SizedBox(height: 80),
            if (state is! UploadingInProgress) _buildControls(context, state),
          ],
        );
      },
    );
  }

  Widget _buildStatusBadge(String text, Color color, bool isRecording) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRecording) ...[
            PulseDot(color: color),
            const SizedBox(width: 8),
          ],
          Text(
            text.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, RecorderState state) {
    if (state is RecordInitial || state is RecordingStopped || state is UploadSuccess) {
      return ControlButton(
        icon: Icons.fiber_manual_record,
        label: 'START RECORDING',
        color: AppTheme.primary,
        onPressed: () => context.read<RecorderBloc>().add(const StartRecordingEvent()),
      );
    }

    return Wrap(
      spacing: 32,
      alignment: WrapAlignment.center,
      children: [
        if (state is RecordingInProgress)
          ControlButton(
            icon: Icons.pause_rounded,
            label: 'PAUSE',
            color: Colors.orangeAccent,
            onPressed: () => context.read<RecorderBloc>().add(PauseRecordingEvent()),
          )
        else if (state is RecordingPaused)
          ControlButton(
            icon: Icons.play_arrow_rounded,
            label: 'RESUME',
            color: Colors.greenAccent,
            onPressed: () => context.read<RecorderBloc>().add(ResumeRecordingEvent()),
          ),
        ControlButton(
          icon: Icons.stop_rounded,
          label: 'STOP',
          color: Colors.redAccent,
          onPressed: () => context.read<RecorderBloc>().add(StopRecordingEvent()),
        ),
      ],
    );
  }

  void _showSaveDialog(BuildContext context, String path) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            const Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent, size: 64),
            const SizedBox(height: 20),
            Text(
              'Recording Completed!',
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              'Your file is securely saved at:\n$path',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Colors.white54, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  context.read<RecorderBloc>().add(UploadRecordingEvent(path: path));
                },
                child: Text('UPLOAD TO BACKEND', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  side: const BorderSide(color: Colors.white12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text('DISMISS', style: GoogleFonts.outfit(color: Colors.white70, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
