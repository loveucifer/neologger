import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/models/food.dart';
import 'package:neologger/models/meal.dart';
import 'package:neologger/providers/meal_provider.dart';
import 'package:neologger/widgets/neologger_button.dart';
import 'package:neologger/widgets/neologger_card.dart';
import 'package:provider/provider.dart';

class FoodDetailScreen extends StatefulWidget {
  final Food food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final TextEditingController _quantityController = TextEditingController();
  String _selectedMealType = 'Breakfast';

  @override
  void initState() {
    super.initState();
    _quantityController.text = '100'; // Default to 100g
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _logFood() {
    final quantity = double.tryParse(_quantityController.text) ?? 100;
    final meal = Meal(
      id: 0,
      foodId: widget.food.id,
      quantity: quantity,
      dateTime: DateTime.now(),
      mealType: _selectedMealType,
    );

    Provider.of<MealProvider>(context, listen: false).addMeal(meal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.food.name,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppFonts.headline3,
          ),
        ),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food header
            NeologgerCard(
              margin: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Food icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.cardBackgroundSecondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.fastfood,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.food.name,
                              style: TextStyle(
                                fontSize: AppFonts.headline3,
                                fontWeight: AppFonts.semiBold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              widget.food.groupName,
                              style: TextStyle(
                                fontSize: AppFonts.bodyMedium,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Per 100g nutrition info
                  Text(
                    'Nutrition per 100g',
                    style: TextStyle(
                      fontSize: AppFonts.headline3,
                      fontWeight: AppFonts.semiBold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _NutritionRow(
                    label: 'Energy',
                    value: '${widget.food.energyKcal.toStringAsFixed(0)} kcal',
                  ),
                  _NutritionRow(
                    label: 'Protein',
                    value: '${widget.food.proteinG.toStringAsFixed(1)} g',
                  ),
                  _NutritionRow(
                    label: 'Fat',
                    value: '${widget.food.fatG.toStringAsFixed(1)} g',
                  ),
                  _NutritionRow(
                    label: 'Carbohydrates',
                    value: '${widget.food.carbohydratesG.toStringAsFixed(1)} g',
                  ),
                  _NutritionRow(
                    label: 'Fiber',
                    value: '${widget.food.fiberG.toStringAsFixed(1)} g',
                  ),
                  _NutritionRow(
                    label: 'Sugar',
                    value: '${widget.food.sugarG.toStringAsFixed(1)} g',
                  ),
                  _NutritionRow(
                    label: 'Calcium',
                    value: '${widget.food.calciumMg.toStringAsFixed(0)} mg',
                  ),
                  _NutritionRow(
                    label: 'Iron',
                    value: '${widget.food.ironMg.toStringAsFixed(1)} mg',
                  ),
                  _NutritionRow(
                    label: 'Vitamin C',
                    value: '${widget.food.vitaminCMg.toStringAsFixed(1)} mg',
                  ),
                ],
              ),
            ),
            
            // Log food section
            NeologgerCard(
              margin: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log this food',
                    style: TextStyle(
                      fontSize: AppFonts.headline3,
                      fontWeight: AppFonts.semiBold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Meal type selector
                  Text(
                    'Meal Type',
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: AppFonts.medium,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
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
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedMealType = newValue;
                          });
                        }
                      },
                      items: <String>['Breakfast', 'Lunch', 'Dinner', 'Snack']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Quantity input
                  Text(
                    'Quantity (grams)',
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: AppFonts.medium,
                      color: AppColors.textPrimary,
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
                      hintText: 'Enter quantity in grams',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Log button
                  NeologgerButton(
                    onPressed: _logFood,
                    text: 'Log Food',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  final String label;
  final String value;

  const _NutritionRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: AppFonts.semiBold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}