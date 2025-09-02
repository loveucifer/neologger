import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';

class NeologgerProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final double height;

  const NeologgerProgressBar({
    super.key,
    required this.progress,
    this.color = AppColors.accent,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSecondary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                width: constraints.maxWidth * progress,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}