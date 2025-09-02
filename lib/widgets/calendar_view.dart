import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/widgets/neologger_card.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Map<DateTime, int> mealCounts;

  const CalendarView({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.mealCounts,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> with SingleTickerProviderStateMixin {
  late DateTime _currentMonth;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
    
    // Animation controller for smoother transitions
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _goToToday() {
    setState(() {
      _currentMonth = DateTime.now();
      _animationController.reset();
      _animationController.forward();
    });
    widget.onDateSelected(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return NeologgerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
                onPressed: _previousMonth,
              ),
              Column(
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(_currentMonth),
                    style: TextStyle(
                      fontSize: AppFonts.headline3,
                      fontWeight: AppFonts.semiBold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: _goToToday,
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontSize: AppFonts.bodySmall,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _CalendarGridView(
                currentMonth: _currentMonth,
                selectedDate: widget.selectedDate,
                onDateSelected: widget.onDateSelected,
                mealCounts: widget.mealCounts,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarGridView extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Map<DateTime, int> mealCounts;

  const _CalendarGridView({
    required this.currentMonth,
    required this.selectedDate,
    required this.onDateSelected,
    required this.mealCounts,
  });

  @override
  Widget build(BuildContext context) {
    // Generate the days of the month
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    
    // Generate the days of the week headers
    final weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    
    // Generate the calendar grid
    List<Widget> children = [];
    
    // Add weekday headers
    for (int i = 0; i < 7; i++) {
      children.add(
        SizedBox(
          height: 30,
          child: Center(
            child: Text(
              weekdays[i],
              style: TextStyle(
                fontSize: AppFonts.caption,
                color: AppColors.textSecondary,
                fontWeight: AppFonts.semiBold,
              ),
            ),
          ),
        ),
      );
    }
    
    // Add empty cells for days before the first day of the month
    // weekday % 7: 0=Sunday, 1=Monday, ..., 6=Saturday
    for (int i = 0; i < (firstDay.weekday % 7); i++) {
      children.add(const SizedBox(height: 40));
    }
    
    // Add the days of the month
    final today = DateTime.now();
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      
      // Create a normalized date for comparison (without time)
      final normalizedSelectedDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      final normalizedDate = DateTime(
        date.year,
        date.month,
        date.day,
      );
      
      final isSelected = normalizedDate.isAtSameMomentAs(normalizedSelectedDate);
      final isToday = normalizedDate.isAtSameMomentAs(today);
      final mealCount = mealCounts[normalizedDate] ?? 0;
      
      // Determine the color based on meal count
      Color dayColor = AppColors.textSecondary;
      if (isSelected) {
        dayColor = AppColors.background;
      } else if (isToday) {
        dayColor = AppColors.accent;
      } else if (mealCount > 0) {
        dayColor = AppColors.textPrimary;
      }
      
      // Determine background color
      Color bgColor = Colors.transparent;
      if (isSelected) {
        bgColor = AppColors.accent;
      } else if (isToday) {
        bgColor = AppColors.cardBackgroundSecondary;
      }
      
      children.add(
        GestureDetector(
          onTap: () => onDateSelected(normalizedDate),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected 
                  ? Border.all(color: AppColors.accent, width: 1)
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: dayColor,
                    fontWeight: isSelected || isToday 
                        ? AppFonts.semiBold 
                        : AppFonts.regular,
                  ),
                ),
                if (mealCount > 0)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.background 
                            : AppColors.accent,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      crossAxisCount: 7,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}