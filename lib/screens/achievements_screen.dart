import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/widgets/neologger_card.dart';
import 'package:neologger/widgets/fade_in_animation.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Achievements',
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
              'Your Nutrition Journey',
              style: TextStyle(
                fontSize: AppFonts.headline2,
                fontWeight: AppFonts.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Streak achievements
            FadeInAnimation(
              delay: const Duration(milliseconds: 100),
              child: NeologgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Streaks',
                      style: TextStyle(
                        fontSize: AppFonts.headline3,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _AchievementItem(
                      icon: Icons.local_fire_department,
                      title: '7-Day Streak',
                      description: 'Log meals for 7 consecutive days',
                      isUnlocked: true,
                      progress: 1.0,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _AchievementItem(
                      icon: Icons.local_fire_department_outlined,
                      title: '14-Day Streak',
                      description: 'Log meals for 14 consecutive days',
                      isUnlocked: false,
                      progress: 0.5,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _AchievementItem(
                      icon: Icons.emoji_events_outlined,
                      title: '30-Day Streak',
                      description: 'Log meals for 30 consecutive days',
                      isUnlocked: false,
                      progress: 0.2,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Goal achievements
            FadeInAnimation(
              delay: const Duration(milliseconds: 200),
              child: NeologgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Goals',
                      style: TextStyle(
                        fontSize: AppFonts.headline3,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _AchievementItem(
                      icon: Icons.restaurant,
                      title: 'Balanced Diet',
                      description: 'Maintain protein/carb/fat ratio for 7 days',
                      isUnlocked: true,
                      progress: 1.0,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _AchievementItem(
                      icon: Icons.eco_outlined,
                      title: 'Green Eater',
                      description: 'Consume 5+ servings of vegetables daily for 5 days',
                      isUnlocked: false,
                      progress: 0.6,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _AchievementItem(
                      icon: Icons.water_drop_outlined,
                      title: 'Hydration Hero',
                      description: 'Log 8+ glasses of water daily for 7 days',
                      isUnlocked: false,
                      progress: 0.3,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Exploration achievements
            FadeInAnimation(
              delay: const Duration(milliseconds: 300),
              child: NeologgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exploration',
                      style: TextStyle(
                        fontSize: AppFonts.headline3,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _AchievementItem(
                      icon: Icons.travel_explore,
                      title: 'Food Explorer',
                      description: 'Log 50 different foods',
                      isUnlocked: false,
                      progress: 0.4,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _AchievementItem(
                      icon: Icons.qr_code_scanner_outlined,
                      title: 'Scanner',
                      description: 'Scan 20+ barcodes',
                      isUnlocked: false,
                      progress: 0.1,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _AchievementItem(
                      icon: Icons.public_outlined,
                      title: 'Global Citizen',
                      description: 'Log foods from 10+ countries',
                      isUnlocked: false,
                      progress: 0.0,
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
}

class _AchievementItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isUnlocked;
  final double progress;

  const _AchievementItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isUnlocked ? AppColors.accent : AppColors.cardBackgroundSecondary,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            icon,
            color: isUnlocked ? AppColors.background : AppColors.textSecondary,
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
                  fontSize: AppFonts.bodyLarge,
                  fontWeight: AppFonts.semiBold,
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
              const SizedBox(height: AppSpacing.sm),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundSecondary,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Container(
                          width: constraints.maxWidth * progress,
                          decoration: BoxDecoration(
                            color: isUnlocked ? AppColors.accent : const Color(0xFF60a5fa),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}