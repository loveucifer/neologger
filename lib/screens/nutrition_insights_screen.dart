import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/providers/meal_provider.dart';
import 'package:neologger/widgets/neologger_card.dart';
import 'package:neologger/widgets/fade_in_animation.dart';
import 'package:provider/provider.dart';

class NutritionInsightsScreen extends StatelessWidget {
  const NutritionInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insights',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppFonts.headline3,
          ),
        ),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition Insights',
              style: TextStyle(
                fontSize: AppFonts.headline2,
                fontWeight: AppFonts.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Today's summary
            FadeInAnimation(
              delay: const Duration(milliseconds: 100),
              child: NeologgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Summary',
                      style: TextStyle(
                        fontSize: AppFonts.headline3,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _InsightItem(
                      icon: Icons.restaurant,
                      title: 'Meals Logged',
                      value: mealProvider.meals.length.toString(),
                      description: 'Keep up the good work!',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _InsightItem(
                      icon: Icons.local_fire_department,
                      title: 'Calories',
                      value: mealProvider.totalCalories.toStringAsFixed(0),
                      description: _getCalorieInsight(mealProvider.totalCalories, mealProvider.calorieGoal),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _InsightItem(
                      icon: Icons.balance,
                      title: 'Protein Intake',
                      value: '${mealProvider.totalProtein.toStringAsFixed(1)}g',
                      description: _getProteinInsight(mealProvider.totalProtein, mealProvider.proteinGoal),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Weekly trends
            FadeInAnimation(
              delay: const Duration(milliseconds: 200),
              child: NeologgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Trends',
                      style: TextStyle(
                        fontSize: AppFonts.headline3,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _InsightItem(
                      icon: Icons.show_chart,
                      title: 'Average Daily Calories',
                      value: '2100',
                      description: 'Slightly above your goal of 2000 kcal',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _InsightItem(
                      icon: Icons.access_time,
                      title: 'Most Active Day',
                      value: 'Wednesday',
                      description: 'You logged 5 meals on Wednesday',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _InsightItem(
                      icon: Icons.favorite,
                      title: 'Favorite Food',
                      value: 'Roti (Whole Wheat)',
                      description: 'Logged 8 times this week',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Recommendations
            FadeInAnimation(
              delay: const Duration(milliseconds: 300),
              child: NeologgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommendations',
                      style: TextStyle(
                        fontSize: AppFonts.headline3,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _RecommendationItem(
                      title: 'Increase Vegetable Intake',
                      description: 'Try to add more green vegetables to your meals',
                      priority: 'Medium',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _RecommendationItem(
                      title: 'Hydrate More',
                      description: 'Aim for 8 glasses of water daily',
                      priority: 'High',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _RecommendationItem(
                      title: 'Balance Macronutrients',
                      description: 'Try to maintain a 40/30/30 ratio of carbs/protein/fat',
                      priority: 'Low',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  static String _getCalorieInsight(double totalCalories, double calorieGoal) {
    final percentage = calorieGoal > 0 ? (totalCalories / calorieGoal) : 0;
    if (percentage < 0.8) {
      return 'You\'re under your calorie goal. Consider eating more if you\'re hungry.';
    } else if (percentage > 1.2) {
      return 'You\'re significantly over your calorie goal. Consider portion control.';
    } else {
      return 'You\'re within a healthy range of your calorie goal.';
    }
  }
  
  static String _getProteinInsight(double totalProtein, double proteinGoal) {
    final percentage = proteinGoal > 0 ? (totalProtein / proteinGoal) : 0;
    if (percentage < 0.8) {
      return 'Consider adding more protein sources like paneer, dal, or eggs.';
    } else if (percentage > 1.2) {
      return 'Great protein intake! Keep up the good work.';
    } else {
      return 'Good protein intake for the day.';
    }
  }
}

class _InsightItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String description;

  const _InsightItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundSecondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: AppFonts.medium,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppFonts.headline3,
                  fontWeight: AppFonts.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: TextStyle(
                  fontSize: AppFonts.bodySmall,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  final String title;
  final String description;
  final String priority;

  const _RecommendationItem({
    required this.title,
    required this.description,
    required this.priority,
  });

  Color _getPriorityColor() {
    switch (priority) {
      case 'High':
        return const Color(0xFFf87171); // Red
      case 'Medium':
        return const Color(0xFFfbbf24); // Yellow
      case 'Low':
        return const Color(0xFF34d399); // Green
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: _getPriorityColor(),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: AppFonts.medium,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: TextStyle(
                  fontSize: AppFonts.bodySmall,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundSecondary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    fontSize: AppFonts.caption,
                    color: _getPriorityColor(),
                    fontWeight: AppFonts.medium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}