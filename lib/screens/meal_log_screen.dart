import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/models/food.dart';
import 'package:neologger/models/meal.dart';
import 'package:neologger/providers/meal_provider.dart';
import 'package:neologger/screens/food_search_screen.dart';
import 'package:neologger/widgets/neologger_button.dart';
import 'package:neologger/widgets/neologger_card.dart';
import 'package:neologger/widgets/fade_in_animation.dart';
import 'package:provider/provider.dart';

class MealLogScreen extends StatefulWidget {
  const MealLogScreen({super.key});

  @override
  State<MealLogScreen> createState() => _MealLogScreenState();
}

class _MealLogScreenState extends State<MealLogScreen> {
  DateTime _selectedDate = DateTime.now();
  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  String _selectedMealType = 'Breakfast';
  Food? _selectedFood;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load today's meals
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealProvider>(context, listen: false).loadMeals(_selectedDate);
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      // Reload meals for the selected date
      Provider.of<MealProvider>(context, listen: false).loadMeals(_selectedDate);
    }
  }

  void _showAddMealDialog() async {
    _selectedFood = null;
    _quantityController.text = '100'; // Default to 100g
    _selectedMealType = 'Breakfast';

    // Show food search screen to select food
    final selectedFood = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FoodSearchScreen(),
      ),
    );

    if (selectedFood != null && selectedFood is Food) {
      setState(() {
        _selectedFood = selectedFood;
      });
      
      // Show dialog to confirm meal details
      _showMealDetailsDialog();
    }
  }

  void _showMealDetailsDialog() {
    if (_selectedFood == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.cardBackground,
              title: Text(
                'Add Meal',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppFonts.headline3,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal type selector
                  Text(
                    'Meal Type',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: AppFonts.semiBold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackgroundSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedMealType,
                      dropdownColor: AppColors.cardBackgroundSecondary,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: AppFonts.bodyMedium,
                      ),
                      underline: Container(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedMealType = newValue;
                          });
                        }
                      },
                      items: _mealTypes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Food selection
                  Text(
                    'Food',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: AppFonts.semiBold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  NeologgerCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        // Food icon placeholder
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.cardBackgroundSecondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.fastfood,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            _selectedFood!.name,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppFonts.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Quantity
                  Text(
                    'Quantity (grams)',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: AppFonts.semiBold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.cardBackgroundSecondary,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                NeologgerButton(
                  onPressed: () {
                    final meal = Meal(
                      id: 0, // Will be set by database
                      foodId: _selectedFood!.id,
                      quantity: double.tryParse(_quantityController.text) ?? 100,
                      dateTime: _selectedDate,
                      mealType: _selectedMealType,
                    );
                    Provider.of<MealProvider>(context, listen: false).addMeal(meal);
                    Navigator.of(context).pop();
                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Meal added successfully!'),
                        backgroundColor: AppColors.cardBackground,
                      ),
                    );
                  },
                  text: 'Add',
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Meal Log',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppFonts.headline3,
                fontWeight: AppFonts.semiBold,
              ),
            ),
            pinned: true,
            backgroundColor: AppColors.background,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAddMealDialog,
              ),
            ],
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NeologgerButton(
                          onPressed: () => _selectDate(context),
                          text: DateFormat('MMM dd, yyyy').format(_selectedDate),
                          icon: Icons.calendar_today,
                          outlined: true,
                        ),
                        Text(
                          '${mealProvider.meals.length} items',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppFonts.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          if (mealProvider.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final meal = mealProvider.meals[index];
                  return Dismissible(
                    key: Key(meal.id.toString()),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      final food = await mealProvider.getFoodById(meal.foodId);
                      if (food == null) return false;
                      
                      // Show confirmation dialog
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: AppColors.cardBackground,
                            title: Text(
                              'Delete Meal',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: AppFonts.headline3,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to delete this ${meal.mealType} entry for ${food.name}?',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: AppFonts.bodyMedium,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                      
                      return confirmed ?? false;
                    },
                    onDismissed: (direction) {
                      mealProvider.deleteMeal(meal.id);
                      // Show a snackbar with undo option
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Meal deleted'),
                          backgroundColor: AppColors.cardBackground,
                        ),
                      );
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: FutureBuilder<Food?>(
                      future: mealProvider.getFoodById(meal.foodId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const _MealListItemSkeleton();
                        }
                        
                        if (snapshot.hasData && snapshot.data != null) {
                          final food = snapshot.data!;
                          return _MealListItem(
                            meal: meal,
                            food: food,
                            onDelete: () {
                              // The Dismissible handles the delete confirmation
                            },
                          );
                        }
                        
                        return const SizedBox.shrink();
                      },
                    ),
                  );
                },
                childCount: mealProvider.meals.length,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMealDialog,
        backgroundColor: AppColors.textPrimary,
        foregroundColor: AppColors.background,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MealListItem extends StatelessWidget {
  final Meal meal;
  final Food food;
  final VoidCallback onDelete;

  const _MealListItem({
    required this.meal,
    required this.food,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 100),
      child: NeologgerCard(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Food icon placeholder
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restaurant,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: TextStyle(
                      fontSize: AppFonts.bodyLarge,
                      fontWeight: AppFonts.semiBold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    meal.mealType,
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${meal.quantity.toStringAsFixed(0)}g • ${((food.energyKcal * meal.quantity) / 100).toStringAsFixed(0)} kcal',
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.textSecondary),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _MealListItemSkeleton extends StatelessWidget {
  const _MealListItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return NeologgerCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Food icon placeholder
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.cardBackgroundSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 16,
                  color: AppColors.cardBackgroundSecondary,
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  width: 80,
                  height: 14,
                  color: AppColors.cardBackgroundSecondary,
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  width: 100,
                  height: 14,
                  color: AppColors.cardBackgroundSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}