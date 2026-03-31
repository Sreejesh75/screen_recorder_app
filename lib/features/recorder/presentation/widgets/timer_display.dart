import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerDisplay extends StatelessWidget {
  final Duration duration;
  final Color color;

  const TimerDisplay({super.key, required this.duration, required this.color});

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        '$minutes:$seconds',
        key: ValueKey(duration.inSeconds),
        style: GoogleFonts.outfit(
          fontSize: 88,
          fontWeight: FontWeight.w200,
          color: Colors.white,
          letterSpacing: -6,
        ),
      ),
    );
  }
}
