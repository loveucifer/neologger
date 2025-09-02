import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/widgets/neologger_card.dart';
import 'package:fl_chart/fl_chart.dart';

class NutritionPieChart extends StatelessWidget {
  final double proteinPercent;
  final double carbsPercent;
  final double fatPercent;

  const NutritionPieChart({
    super.key,
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
  });

  @override
  Widget build(BuildContext context) {
    return NeologgerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Distribution',
            style: TextStyle(
              fontSize: AppFonts.headline3,
              fontWeight: AppFonts.semiBold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFF60a5fa), // Blue for protein
                    value: proteinPercent,
                    title: '${proteinPercent.toStringAsFixed(0)}%',
                    radius: 50,
                    titleStyle: TextStyle(
                      fontSize: AppFonts.caption,
                      fontWeight: AppFonts.medium,
                      color: AppColors.background,
                    ),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFF34d399), // Green for carbs
                    value: carbsPercent,
                    title: '${carbsPercent.toStringAsFixed(0)}%',
                    radius: 50,
                    titleStyle: TextStyle(
                      fontSize: AppFonts.caption,
                      fontWeight: AppFonts.medium,
                      color: AppColors.background,
                    ),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFfbbf24), // Yellow for fat
                    value: fatPercent,
                    title: '${fatPercent.toStringAsFixed(0)}%',
                    radius: 50,
                    titleStyle: TextStyle(
                      fontSize: AppFonts.caption,
                      fontWeight: AppFonts.medium,
                      color: AppColors.background,
                    ),
                  ),
                ],
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LegendItem(
                color: const Color(0xFF60a5fa),
                label: 'Protein',
                value: '${proteinPercent.toStringAsFixed(1)}%',
              ),
              _LegendItem(
                color: const Color(0xFF34d399),
                label: 'Carbs',
                value: '${carbsPercent.toStringAsFixed(1)}%',
              ),
              _LegendItem(
                color: const Color(0xFFfbbf24),
                label: 'Fat',
                value: '${fatPercent.toStringAsFixed(1)}%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: TextStyle(
            fontSize: AppFonts.bodySmall,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}