import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';

class DottedGridBackground extends StatelessWidget {
  final Widget child;

  const DottedGridBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dotted grid background
        LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: DottedGridPainter(),
            );
          },
        ),
        // Content
        child,
      ],
    );
  }
}

class DottedGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.cardBackgroundSecondary
      ..strokeWidth = 1;

    const double dotSpacing = 20.0;
    const double dotRadius = 1.0;

    for (double x = 0; x < size.width; x += dotSpacing) {
      for (double y = 0; y < size.height; y += dotSpacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}