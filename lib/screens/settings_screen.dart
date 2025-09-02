import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/providers/meal_provider.dart';
import 'package:neologger/widgets/neologger_card.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  late TextEditingController _calorieController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  late TextEditingController _fiberController;
  late TextEditingController _sugarController;
  late TextEditingController _calciumController;
  late TextEditingController _ironController;
  late TextEditingController _vitaminCController;

  @override
  void initState() {
    super.initState();
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    
    _calorieController = TextEditingController(text: mealProvider.calorieGoal.toString());
    _proteinController = TextEditingController(text: mealProvider.proteinGoal.toString());
    _carbsController = TextEditingController(text: mealProvider.carbsGoal.toString());
    _fatController = TextEditingController(text: mealProvider.fatGoal.toString());
    _fiberController = TextEditingController(text: mealProvider.fiberGoal.toString());
    _sugarController = TextEditingController(text: mealProvider.sugarGoal.toString());
    _calciumController = TextEditingController(text: mealProvider.calciumGoal.toString());
    _ironController = TextEditingController(text: mealProvider.ironGoal.toString());
    _vitaminCController = TextEditingController(text: mealProvider.vitaminCGoal.toString());
  }

  @override
  void dispose() {
    _calorieController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    _sugarController.dispose();
    _calciumController.dispose();
    _ironController.dispose();
    _vitaminCController.dispose();
    super.dispose();
  }

  void _saveGoals() {
    if (_formKey.currentState!.validate()) {
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      
      mealProvider.setGoals(
        calories: double.tryParse(_calorieController.text) ?? mealProvider.calorieGoal,
        protein: double.tryParse(_proteinController.text) ?? mealProvider.proteinGoal,
        carbs: double.tryParse(_carbsController.text) ?? mealProvider.carbsGoal,
        fat: double.tryParse(_fatController.text) ?? mealProvider.fatGoal,
        fiber: double.tryParse(_fiberController.text) ?? mealProvider.fiberGoal,
        sugar: double.tryParse(_sugarController.text) ?? mealProvider.sugarGoal,
        calcium: double.tryParse(_calciumController.text) ?? mealProvider.calciumGoal,
        iron: double.tryParse(_ironController.text) ?? mealProvider.ironGoal,
        vitaminC: double.tryParse(_vitaminCController.text) ?? mealProvider.vitaminCGoal,
      );
      
      mealProvider.saveGoals();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goals saved successfully!'),
          backgroundColor: AppColors.cardBackground,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppFonts.headline3,
          ),
        ),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nutrition Goals',
                style: TextStyle(
                  fontSize: AppFonts.headline2,
                  fontWeight: AppFonts.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Macro nutrients
              NeologgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Macronutrients',
                      style: TextStyle(
                        fontSize: AppFonts.headline3,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _calorieController,
                      label: 'Calories',
                      suffix: 'kcal',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _proteinController,
                      label: 'Protein',
                      suffix: 'g',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _carbsController,
                      label: 'Carbohydrates',
                      suffix: 'g',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _fatController,
                      label: 'Fat',
                      suffix: 'g',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Micro nutrients
              NeologgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Micronutrients',
                      style: TextStyle(
                        fontSize: AppFonts.headline3,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _fiberController,
                      label: 'Fiber',
                      suffix: 'g',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _sugarController,
                      label: 'Sugar',
                      suffix: 'g',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _calciumController,
                      label: 'Calcium',
                      suffix: 'mg',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _ironController,
                      label: 'Iron',
                      suffix: 'mg',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _vitaminCController,
                      label: 'Vitamin C',
                      suffix: 'mg',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Save button
              Center(
                child: ElevatedButton(
                  onPressed: _saveGoals,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save Goals'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            fontWeight: AppFonts.medium,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            suffixText: suffix,
            suffixStyle: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppFonts.bodyMedium,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }
}