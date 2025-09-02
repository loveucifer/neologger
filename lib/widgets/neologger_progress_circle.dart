import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';

class NeologgerProgressCircle extends StatelessWidget {
  final double progress;
  final double size;
  final Color color;
  final String label;
  final String value;
  final String unit;

  const NeologgerProgressCircle({
    super.key,
    required this.progress,
    this.size = 120,
    this.color = AppColors.accent,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundSecondary,
                shape: BoxShape.circle,
              ),
            ),
            // Progress circle
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 6,
                backgroundColor: AppColors.cardBackgroundSecondary,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            // Center text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppFonts.headline3,
                    fontWeight: AppFonts.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: AppFonts.caption,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}