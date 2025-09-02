import 'package:flutter/foundation.dart';
import 'package:neologger/database/database_helper.dart';
import 'package:neologger/models/meal.dart';
import 'package:neologger/models/food.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];
  Map<int, Food> _foodsCache = {};
  bool _isLoading = false;
  double _totalCalories = 0;
  double _totalProtein = 0;
  double _totalCarbs = 0;
  double _totalFat = 0;
  double _totalFiber = 0;
  double _totalSugar = 0;
  double _totalCalcium = 0;
  double _totalIron = 0;
  double _totalVitaminC = 0;
  
  // Goals
  double _calorieGoal = 2000;
  double _proteinGoal = 150;
  double _carbsGoal = 300;
  double _fatGoal = 70;
  double _fiberGoal = 25;
  double _sugarGoal = 50;
  double _calciumGoal = 1000;
  double _ironGoal = 18;
  double _vitaminCGoal = 90;

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;
  
  // Nutrition totals
  double get totalCalories => _totalCalories;
  double get totalProtein => _totalProtein;
  double get totalCarbs => _totalCarbs;
  double get totalFat => _totalFat;
  double get totalFiber => _totalFiber;
  double get totalSugar => _totalSugar;
  double get totalCalcium => _totalCalcium;
  double get totalIron => _totalIron;
  double get totalVitaminC => _totalVitaminC;
  
  // Goals
  double get calorieGoal => _calorieGoal;
  double get proteinGoal => _proteinGoal;
  double get carbsGoal => _carbsGoal;
  double get fatGoal => _fatGoal;
  double get fiberGoal => _fiberGoal;
  double get sugarGoal => _sugarGoal;
  double get calciumGoal => _calciumGoal;
  double get ironGoal => _ironGoal;
  double get vitaminCGoal => _vitaminCGoal;

  // Progress
  double get calorieProgress => _calorieGoal > 0 ? _totalCalories / _calorieGoal : 0;
  double get proteinProgress => _proteinGoal > 0 ? _totalProtein / _proteinGoal : 0;
  double get carbsProgress => _carbsGoal > 0 ? _totalCarbs / _carbsGoal : 0;
  double get fatProgress => _fatGoal > 0 ? _totalFat / _fatGoal : 0;
  double get fiberProgress => _fiberGoal > 0 ? _totalFiber / _fiberGoal : 0;
  double get sugarProgress => _sugarGoal > 0 ? _totalSugar / _sugarGoal : 0;
  double get calciumProgress => _calciumGoal > 0 ? _totalCalcium / _calciumGoal : 0;
  double get ironProgress => _ironGoal > 0 ? _totalIron / _ironGoal : 0;
  double get vitaminCProgress => _vitaminCGoal > 0 ? _totalVitaminC / _vitaminCGoal : 0;

  Future<void> loadMeals(DateTime date) async {
    _isLoading = true;
    notifyListeners();

    try {
      final dbHelper = DatabaseHelper();
      _meals = await dbHelper.getMealsByDate(date);
      
      // Calculate totals
      await _calculateTotals();
    } catch (e) {
      // Handle error
      print('Error loading meals: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMeal(Meal meal) async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.insertMeal(meal);
      
      // Reload meals
      await loadMeals(meal.dateTime);
      notifyListeners(); // Ensure listeners are notified
    } catch (e) {
      // Handle error
      print('Error adding meal: $e');
    }
  }

  Future<void> updateMeal(Meal meal) async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.updateMeal(meal);
      
      // Reload meals
      await loadMeals(meal.dateTime);
    } catch (e) {
      // Handle error
      print('Error updating meal: $e');
    }
  }

  Future<void> deleteMeal(int id) async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.deleteMeal(id);
      
      // Reload meals
      await loadMeals(DateTime.now());
    } catch (e) {
      // Handle error
      print('Error deleting meal: $e');
    }
  }

  Future<Food?> getFoodById(int id) async {
    // Check cache first
    if (_foodsCache.containsKey(id)) {
      return _foodsCache[id];
    }

    try {
      final dbHelper = DatabaseHelper();
      final food = await dbHelper.getFoodById(id);
      
      if (food != null) {
        _foodsCache[id] = food;
      }
      
      return food;
    } catch (e) {
      // Handle error
      print('Error getting food by id: $e');
      return null;
    }
  }

  Future<void> _calculateTotals() async {
    _totalCalories = 0;
    _totalProtein = 0;
    _totalCarbs = 0;
    _totalFat = 0;
    _totalFiber = 0;
    _totalSugar = 0;
    _totalCalcium = 0;
    _totalIron = 0;
    _totalVitaminC = 0;

    for (var meal in _meals) {
      final food = await getFoodById(meal.foodId);
      if (food != null) {
        _totalCalories += (food.energyKcal * meal.quantity) / 100;
        _totalProtein += (food.proteinG * meal.quantity) / 100;
        _totalCarbs += (food.carbohydratesG * meal.quantity) / 100;
        _totalFat += (food.fatG * meal.quantity) / 100;
        _totalFiber += (food.fiberG * meal.quantity) / 100;
        _totalSugar += (food.sugarG * meal.quantity) / 100;
        _totalCalcium += (food.calciumMg * meal.quantity) / 100;
        _totalIron += (food.ironMg * meal.quantity) / 100;
        _totalVitaminC += (food.vitaminCMg * meal.quantity) / 100;
      }
    }
  }

  void setGoals({
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    double? sugar,
    double? calcium,
    double? iron,
    double? vitaminC,
  }) {
    if (calories != null) _calorieGoal = calories;
    if (protein != null) _proteinGoal = protein;
    if (carbs != null) _carbsGoal = carbs;
    if (fat != null) _fatGoal = fat;
    if (fiber != null) _fiberGoal = fiber;
    if (sugar != null) _sugarGoal = sugar;
    if (calcium != null) _calciumGoal = calcium;
    if (iron != null) _ironGoal = iron;
    if (vitaminC != null) _vitaminCGoal = vitaminC;
    
    notifyListeners();
  }

  // Load goals from shared preferences
  Future<void> loadGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _calorieGoal = prefs.getDouble('calorieGoal') ?? 2000;
      _proteinGoal = prefs.getDouble('proteinGoal') ?? 150;
      _carbsGoal = prefs.getDouble('carbsGoal') ?? 300;
      _fatGoal = prefs.getDouble('fatGoal') ?? 70;
      _fiberGoal = prefs.getDouble('fiberGoal') ?? 25;
      _sugarGoal = prefs.getDouble('sugarGoal') ?? 50;
      _calciumGoal = prefs.getDouble('calciumGoal') ?? 1000;
      _ironGoal = prefs.getDouble('ironGoal') ?? 18;
      _vitaminCGoal = prefs.getDouble('vitaminCGoal') ?? 90;
      
      notifyListeners();
    } catch (e) {
      print('Error loading goals: $e');
    }
  }
  
  // Save goals to shared preferences
  Future<void> saveGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setDouble('calorieGoal', _calorieGoal);
      await prefs.setDouble('proteinGoal', _proteinGoal);
      await prefs.setDouble('carbsGoal', _carbsGoal);
      await prefs.setDouble('fatGoal', _fatGoal);
      await prefs.setDouble('fiberGoal', _fiberGoal);
      await prefs.setDouble('sugarGoal', _sugarGoal);
      await prefs.setDouble('calciumGoal', _calciumGoal);
      await prefs.setDouble('ironGoal', _ironGoal);
      await prefs.setDouble('vitaminCGoal', _vitaminCGoal);
    } catch (e) {
      print('Error saving goals: $e');
    }
  }
}