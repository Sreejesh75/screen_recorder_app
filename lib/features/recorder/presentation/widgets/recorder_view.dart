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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: BlocConsumer<RecorderBloc, RecorderState>(
        listener: (context, state) {
          if (state is RecordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.redAccent,
                duration: const Duration(seconds: 5),
                action:
                    state.isUploadError &&
                        state.path != null &&
                        state.durationSeconds != null
                    ? SnackBarAction(
                        label: 'Retry',
                        textColor: Colors.white,
                        onPressed: () {
                          context.read<RecorderBloc>().add(
                            UploadRecordingEvent(
                              path: state.path!,
                              durationSeconds: state.durationSeconds!,
                            ),
                          );
                        },
                      )
                    : null,
              ),
            );
          }
          if (state is RecordingStopped) {
            _showSnackBar(
              context,
              'Saved locally. Uploading to backend...',
              AppTheme.accent,
            );
            context.read<RecorderBloc>().add(
              UploadRecordingEvent(
                path: state.path,
                durationSeconds: state.durationSeconds,
              ),
            );
          }
          if (state is UploadSuccess) {
            _showSnackBar(context, state.message, Colors.green);
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
              TimerDisplay(duration: duration, color: statusColor),
              const SizedBox(height: 16),
              _buildStatusBadge(
                status,
                statusColor,
                state is RecordingInProgress,
              ),
              const SizedBox(height: 80),
              _buildControls(context, state),
            ],
          );
        },
      ),
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
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, RecorderState state) {
    if (state is! RecordingInProgress && state is! RecordingPaused) {
      return ControlButton(
        icon: Icons.fiber_manual_record,
        label: 'START RECORDING',
        color: AppTheme.primary,
        onPressed: () =>
            context.read<RecorderBloc>().add(const StartRecordingEvent()),
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
            onPressed: () =>
                context.read<RecorderBloc>().add(PauseRecordingEvent()),
          )
        else if (state is RecordingPaused)
          ControlButton(
            icon: Icons.play_arrow_rounded,
            label: 'RESUME',
            color: Colors.greenAccent,
            onPressed: () =>
                context.read<RecorderBloc>().add(ResumeRecordingEvent()),
          ),
        ControlButton(
          icon: Icons.stop_rounded,
          label: 'STOP',
          color: Colors.redAccent,
          onPressed: () =>
              context.read<RecorderBloc>().add(StopRecordingEvent()),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}
