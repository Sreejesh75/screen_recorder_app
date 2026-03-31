import 'package:flutter/material.dart';
import 'package:screen_recorder_/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_recorder_/features/recorder/presentation/widgets/background_glow.dart';
import 'package:screen_recorder_/features/recorder/presentation/widgets/history_bottom_sheet.dart';
import 'package:screen_recorder_/features/recorder/presentation/widgets/recorder_view.dart';

class RecorderPage extends StatelessWidget {
  const RecorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Ensures full width to fix "side shape" issue
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppTheme.background,
        ),
        child: Stack(
          children: [
            // Premium background background glow effects
            const BackgroundGlow(
              color: AppTheme.primary,
              position: Offset(-100, -100),
              size: 300,
            ),
            const BackgroundGlow(
              color: AppTheme.accent,
              position: Offset(200, 400),
              size: 400,
            ),
            
            // Interaction Layer
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, 
                children: [
                  const SizedBox(height: 32),
                  _buildHeader(context),
                  const Expanded(child: RecorderView()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Screen Recorder',
                  style: GoogleFonts.outfit(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Capture your screen highlights',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white38,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  height: 4,
                  width: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.accent],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => HistoryBottomSheet.show(context),
            icon: const Icon(Icons.history_rounded, color: Colors.white70, size: 28),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.05),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
