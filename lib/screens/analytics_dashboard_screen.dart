import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/providers/meal_provider.dart';
import 'package:neologger/widgets/neologger_card.dart';
import 'package:neologger/widgets/fade_in_animation.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 6));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Load data for the selected date range
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    // In a real app, this would load data for the date range
    // For now, we'll just trigger a refresh
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    mealProvider.loadMeals(_selectedDate);
  }

  void _selectDateRange() async {
    // Show date range picker
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.textPrimary,
              onPrimary: AppColors.background,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppFonts.headline3,
          ),
        ),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition Analytics',
              style: TextStyle(
                fontSize: AppFonts.headline2,
                fontWeight: AppFonts.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${DateFormat('MMM dd, yyyy').format(_startDate)} - ${DateFormat('MMM dd, yyyy').format(_endDate)}',
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Weekly macro trends
            FadeInAnimation(
              delay: const Duration(milliseconds: 100),
              child: NeologgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Macro Trends',
                      style: TextStyle(
                        fontSize: AppFonts.headline3,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: 200,
                      child: _MacroTrendChart(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Daily nutrition summary
            FadeInAnimation(
              delay: const Duration(milliseconds: 200),
              child: NeologgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Nutrition Summary',
                      style: TextStyle(
                        fontSize: AppFonts.headline3,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _DailyNutritionBar(
                      label: 'Calories',
                      currentValue: mealProvider.totalCalories,
                      goalValue: mealProvider.calorieGoal,
                      unit: 'kcal',
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DailyNutritionBar(
                      label: 'Protein',
                      currentValue: mealProvider.totalProtein,
                      goalValue: mealProvider.proteinGoal,
                      unit: 'g',
                      color: const Color(0xFF60a5fa),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DailyNutritionBar(
                      label: 'Carbs',
                      currentValue: mealProvider.totalCarbs,
                      goalValue: mealProvider.carbsGoal,
                      unit: 'g',
                      color: const Color(0xFF34d399),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DailyNutritionBar(
                      label: 'Fat',
                      currentValue: mealProvider.totalFat,
                      goalValue: mealProvider.fatGoal,
                      unit: 'g',
                      color: const Color(0xFFfbbf24),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Weekly meal distribution
            FadeInAnimation(
              delay: const Duration(milliseconds: 300),
              child: NeologgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Meal Distribution',
                      style: TextStyle(
                        fontSize: AppFonts.headline3,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: 200,
                      child: _MealDistributionChart(),
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

class _MacroTrendChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    // In a real app, this would come from the database
    final List<FlSpot> caloriesSpots = [
      const FlSpot(0, 1800),
      const FlSpot(1, 2100),
      const FlSpot(2, 1950),
      const FlSpot(3, 2200),
      const FlSpot(4, 2050),
      const FlSpot(5, 1900),
      const FlSpot(6, 2300),
    ];
    
    final List<FlSpot> proteinSpots = [
      const FlSpot(0, 120),
      const FlSpot(1, 140),
      const FlSpot(2, 130),
      const FlSpot(3, 150),
      const FlSpot(4, 145),
      const FlSpot(5, 125),
      const FlSpot(6, 160),
    ];
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 500,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.cardBackgroundSecondary,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return Text(
                  weekdays[value.toInt()],
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppFonts.caption,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 500,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppFonts.caption,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppColors.cardBackgroundSecondary),
        ),
        minX: 0,
        maxX: 6,
        minY: 1000,
        maxY: 2500,
        lineBarsData: [
          LineChartBarData(
            spots: caloriesSpots,
            isCurved: true,
            color: AppColors.accent,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: proteinSpots,
            isCurved: true,
            color: const Color(0xFF60a5fa),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

class _DailyNutritionBar extends StatelessWidget {
  final String label;
  final double currentValue;
  final double goalValue;
  final String unit;
  final Color color;

  const _DailyNutritionBar({
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
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundSecondary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MealDistributionChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    // In a real app, this would come from the database
    final List<PieChartSectionData> sections = [
      PieChartSectionData(
        color: const Color(0xFF60a5fa),
        value: 25,
        title: 'Breakfast',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: AppFonts.caption,
          fontWeight: AppFonts.medium,
          color: AppColors.background,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xFF34d399),
        value: 35,
        title: 'Lunch',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: AppFonts.caption,
          fontWeight: AppFonts.medium,
          color: AppColors.background,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xFFfbbf24),
        value: 30,
        title: 'Dinner',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: AppFonts.caption,
          fontWeight: AppFonts.medium,
          color: AppColors.background,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xFFa78bfa),
        value: 10,
        title: 'Snacks',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: AppFonts.caption,
          fontWeight: AppFonts.medium,
          color: AppColors.background,
        ),
      ),
    ];
    
    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }
}