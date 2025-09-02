import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/widgets/neologger_card.dart';

class ContributionGraph extends StatelessWidget {
  final Map<DateTime, int> contributions;
  final DateTime startDate;
  final DateTime endDate;

  const ContributionGraph({
    super.key,
    required this.contributions,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a list of dates for the graph
    List<DateTime> dates = [];
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return NeologgerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Activity',
            style: TextStyle(
              fontSize: AppFonts.headline3,
              fontWeight: AppFonts.semiBold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Graph visualization
          _ContributionGridView(
            dates: dates,
            contributions: contributions,
          ),
          const SizedBox(height: AppSpacing.md),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Less',
                style: TextStyle(
                  fontSize: AppFonts.caption,
                  color: AppColors.textSecondary,
                ),
              ),
              _LegendItem(color: AppColors.cardBackgroundSecondary, label: '0'),
              _LegendItem(color: const Color(0xFF0d4429), label: '1-2'),
              _LegendItem(color: const Color(0xFF006d32), label: '3-4'),
              _LegendItem(color: const Color(0xFF39d353), label: '5+'),
              Text(
                'More',
                style: TextStyle(
                  fontSize: AppFonts.caption,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContributionGridView extends StatelessWidget {
  final List<DateTime> dates;
  final Map<DateTime, int> contributions;

  const _ContributionGridView({
    required this.dates,
    required this.contributions,
  });

  @override
  Widget build(BuildContext context) {
    // Group dates by week
    List<List<DateTime>> weeks = [];
    List<DateTime> currentWeek = [];
    
    for (int i = 0; i < dates.length; i++) {
      DateTime date = dates[i];
      
      // Start a new week on Monday
      if (date.weekday == DateTime.monday || currentWeek.isEmpty) {
        if (currentWeek.isNotEmpty) {
          weeks.add(currentWeek);
        }
        currentWeek = [date];
      } else {
        currentWeek.add(date);
      }
      
      // Add the last week
      if (i == dates.length - 1 && currentWeek.isNotEmpty) {
        weeks.add(currentWeek);
      }
    }
    
    // Limit to 12 weeks for better visualization
    if (weeks.length > 12) {
      weeks = weeks.sublist(weeks.length - 12);
    }

    return Column(
      children: weeks.map((week) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: week.map((date) {
              int count = contributions[date] ?? 0;
              Color color = AppColors.cardBackgroundSecondary;
              
              // GitHub-style green gradient colors
              if (count > 0 && count <= 1) {
                color = const Color(0xFF0d4429);
              } else if (count > 1 && count <= 2) {
                color = const Color(0xFF006d32);
              } else if (count > 2 && count <= 3) {
                color = const Color(0xFF26a641);
              } else if (count > 3) {
                color = const Color(0xFF39d353);
              }
              
              return Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
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
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.caption,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}