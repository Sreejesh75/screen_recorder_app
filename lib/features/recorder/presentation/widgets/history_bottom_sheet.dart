import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:screen_recorder_/core/theme/app_theme.dart';
import 'package:screen_recorder_/features/recorder/presentation/widgets/video_player_screen.dart';

class HistoryBottomSheet extends StatelessWidget {
  const HistoryBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const HistoryBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Local Recordings',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box('recordings').listenable(),
                  builder: (context, Box box, _) {
                    if (box.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.videocam_off_rounded,
                              size: 64,
                              color: Colors.white24,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No recordings saved yet.',
                              style: GoogleFonts.outfit(
                                color: Colors.white54,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        
                        final Map data = box.getAt(box.length - 1 - index);
                        final DateTime date = DateTime.parse(
                          data['date'] as String,
                        );
                        final int duration = data['durationSeconds'] as int;
                        final String path = data['path'] as String;

                      
                        String twoDigits(int n) => n.toString().padLeft(2, "0");
                        final min = twoDigits(duration ~/ 60);
                        final sec = twoDigits(duration % 60);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerScreen(
                                  path: path,
                                  fileName: path.split('/').last,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.video_file_rounded,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        path.split('/').last,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${date.toLocal().toString().split('.')[0]} • $min:$sec',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final file = XFile(path);
                                    await Share.shareXFiles(
                                      [file],
                                      text: 'Check out my screen recording!',
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.share_rounded,
                                    color: Colors.blueAccent,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  onPressed: () async {
                                    final bool? confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: AppTheme.surface,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        icon: Lottie.asset(
                                          'assets/lottie/Delete_bubble_lottie.json',
                                          height: 120,
                                          repeat: false,
                                        ),
                                        title: Text('Delete Recording', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                                        content: Text(
                                          'Are you sure you want to permanently delete this video?',
                                          style: GoogleFonts.outfit(color: Colors.white70),
                                          textAlign: TextAlign.center,
                                        ),
                                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: Text('Cancel', style: GoogleFonts.outfit(color: Colors.white54, fontWeight: FontWeight.w600)),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent.withOpacity(0.2),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            child: Text('Delete', style: GoogleFonts.outfit(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      final file = File(path);
                                      if (await file.exists()) {
                                        await file.delete();
                                      }
                                      await box.deleteAt(box.length - 1 - index);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.redAccent,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.red.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
  }
}
