import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/providers/meal_provider.dart';
import 'package:neologger/widgets/neologger_card.dart';
import 'package:neologger/widgets/neologger_progress_bar.dart';
import 'package:neologger/widgets/nutrition_pie_chart.dart';
import 'package:provider/provider.dart';

class NutritionSummary extends StatelessWidget {
  const NutritionSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    
    // Calculate macro percentages
    final totalMacros = mealProvider.totalProtein * 4 + 
                        mealProvider.totalCarbs * 4 + 
                        mealProvider.totalFat * 9;
    
    final proteinPercent = totalMacros > 0 
        ? ((mealProvider.totalProtein * 4) / totalMacros) * 100 
        : 0.0;
    final carbsPercent = totalMacros > 0 
        ? ((mealProvider.totalCarbs * 4) / totalMacros) * 100 
        : 0.0;
    final fatPercent = totalMacros > 0 
        ? ((mealProvider.totalFat * 9) / totalMacros) * 100 
        : 0.0;
    
    return Column(
      children: [
        NeologgerCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Nutrition',
                style: TextStyle(
                  fontSize: AppFonts.headline3,
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Macro nutrients
              _NutritionProgressBar(
                label: 'Calories',
                currentValue: mealProvider.totalCalories,
                goalValue: mealProvider.calorieGoal,
                unit: 'kcal',
                color: AppColors.accent,
              ),
              const SizedBox(height: AppSpacing.md),
              _NutritionProgressBar(
                label: 'Protein',
                currentValue: mealProvider.totalProtein,
                goalValue: mealProvider.proteinGoal,
                unit: 'g',
                color: const Color(0xFF60a5fa), // Blue
              ),
              const SizedBox(height: AppSpacing.md),
              _NutritionProgressBar(
                label: 'Carbs',
                currentValue: mealProvider.totalCarbs,
                goalValue: mealProvider.carbsGoal,
                unit: 'g',
                color: const Color(0xFF34d399), // Green
              ),
              const SizedBox(height: AppSpacing.md),
              _NutritionProgressBar(
                label: 'Fat',
                currentValue: mealProvider.totalFat,
                goalValue: mealProvider.fatGoal,
                unit: 'g',
                color: const Color(0xFFfbbf24), // Yellow
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        NutritionPieChart(
          proteinPercent: proteinPercent,
          carbsPercent: carbsPercent,
          fatPercent: fatPercent,
        ),
      ],
    );
  }
}

class _NutritionProgressBar extends StatelessWidget {
  final String label;
  final double currentValue;
  final double goalValue;
  final String unit;
  final Color color;

  const _NutritionProgressBar({
    required this.label,
    required this.currentValue,
    required this.goalValue,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goalValue > 0 ? (currentValue / goalValue).clamp(0.0, 1.0) : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                fontWeight: AppFonts.medium,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${currentValue.toStringAsFixed(1)} / ${goalValue.toStringAsFixed(0)} $unit',
              style: TextStyle(
                fontSize: AppFonts.bodySmall,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        NeologgerProgressBar(
          progress: progress,
          color: color,
        ),
      ],
    );
  }
}