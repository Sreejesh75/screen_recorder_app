import 'package:flutter/material.dart';

class BackgroundGlow extends StatelessWidget {
  final Color color;
  final Offset position;
  final double size;

  const BackgroundGlow({
    super.key,
    required this.color,
    required this.position,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 100,
              spreadRadius: 40,
            ),
          ],
        ),
      ),
    );
  }
}
