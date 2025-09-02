import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/database/database_helper.dart';
import 'package:neologger/providers/meal_provider.dart';
import 'package:neologger/screens/food_search_screen.dart';
import 'package:neologger/screens/meal_log_screen.dart';
import 'package:neologger/screens/barcode_scanner_screen.dart';
import 'package:neologger/screens/settings_screen.dart';
import 'package:neologger/widgets/neologger_button.dart';
import 'package:neologger/widgets/nutrition_summary.dart';
import 'package:neologger/widgets/calendar_view.dart';
import 'package:neologger/widgets/fade_in_animation.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    MealLogScreen(),
    FoodSearchScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neologger'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Meals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Foods',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DateTime _selectedDate;
  Map<DateTime, int> _mealCounts = {};

  @override
  void initState() {
    super.initState();
    // Initialize with today's date (normalized)
    _selectedDate = DateTime.now();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    
    // Load meal data for today
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      mealProvider.loadMeals(_selectedDate);
      mealProvider.loadGoals();
      _loadMealCounts();
    });
  }

  void _loadMealCounts() async {
    try {
      final dbHelper = DatabaseHelper();
      final allMeals = await dbHelper.getAllMeals();
      
      final mealCounts = <DateTime, int>{};
      
      // Group meals by date
      for (var meal in allMeals) {
        // Normalize the date to remove time component
        final normalizedDate = DateTime(meal.dateTime.year, meal.dateTime.month, meal.dateTime.day);
        
        if (mealCounts.containsKey(normalizedDate)) {
          mealCounts[normalizedDate] = mealCounts[normalizedDate]! + 1;
        } else {
          mealCounts[normalizedDate] = 1;
        }
      }
      
      setState(() {
        _mealCounts = mealCounts;
      });
    } catch (e) {
      print('Error loading meal counts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    
    // Reload meal counts when meals change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMealCounts();
    });
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          // Welcome section
          FadeInAnimation(
            delay: const Duration(milliseconds: 100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: AppFonts.headline3,
                      fontWeight: AppFonts.regular,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Track your nutrition',
                    style: TextStyle(
                      fontSize: AppFonts.headline2,
                      fontWeight: AppFonts.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Calendar view
          FadeInAnimation(
            delay: const Duration(milliseconds: 200),
            child: CalendarView(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                // Normalize the date to remove time component
                final normalizedDate = DateTime(date.year, date.month, date.day);
                setState(() {
                  _selectedDate = normalizedDate;
                });
                // Load meals for the selected date
                mealProvider.loadMeals(normalizedDate);
              },
              mealCounts: _mealCounts,
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Nutrition summary
          FadeInAnimation(
            delay: const Duration(milliseconds: 300),
            child: NutritionSummary(),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Quick actions
          FadeInAnimation(
            delay: const Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: NeologgerButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MealLogScreen(),
                              ),
                            );
                          },
                          text: 'Log Meal',
                          icon: Icons.restaurant,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: NeologgerButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FoodSearchScreen(),
                              ),
                            );
                          },
                          text: 'Search Food',
                          icon: Icons.search,
                          outlined: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  NeologgerButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BarcodeScannerScreen(),
                        ),
                      );
                      if (result != null) {
                        // Handle scanned food
                        // In a real app, you would navigate to the food detail screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Found food: ${result['name']}',
                              style: const TextStyle(color: AppColors.textPrimary),
                            ),
                            backgroundColor: AppColors.cardBackground,
                          ),
                        );
                      }
                    },
                    text: 'Scan Barcode',
                    icon: Icons.qr_code_scanner,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}