import 'package:flutter/foundation.dart';
import 'package:neologger/database/database_helper.dart';
import 'package:neologger/models/food.dart';

class FoodProvider with ChangeNotifier {
  List<Food> _foods = [];
  String _openFoodFactsApiKey = '';
  bool _isLoading = false;

  List<Food> get foods => _foods;
  String get openFoodFactsApiKey => _openFoodFactsApiKey;
  bool get isLoading => _isLoading;

  Future<void> loadFoods() async {
    _isLoading = true;
    notifyListeners();

    try {
      final dbHelper = DatabaseHelper();
      _foods = await dbHelper.getAllFoods();
    } catch (e) {
      // Handle error
      print('Error loading foods: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchFoods(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      final dbHelper = DatabaseHelper();
      // First search local database
      _foods = await dbHelper.searchFoods(query);
      
      // If we don't have enough results, try Open Food Facts
      if (_foods.length < 10) {
        final openFoodFactsFoods = await dbHelper.searchFoodsExtended(query);
        // Combine local and Open Food Facts results
        final Set<String> existingNames = {};
        final List<Food> combinedFoods = [];
        
        // Add local foods first
        for (var food in _foods) {
          if (!existingNames.contains(food.name)) {
            existingNames.add(food.name);
            combinedFoods.add(food);
          }
        }
        
        // Add Open Food Facts foods
        for (var food in openFoodFactsFoods) {
          if (!existingNames.contains(food.name)) {
            existingNames.add(food.name);
            combinedFoods.add(food);
          }
        }
        
        _foods = combinedFoods;
      }
    } catch (e) {
      print('Error searching foods: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Food?> getFoodById(int id) async {
    try {
      final dbHelper = DatabaseHelper();
      return await dbHelper.getFoodById(id);
    } catch (e) {
      // Handle error
      print('Error getting food by id: $e');
      return null;
    }
  }

  Future<Food?> getFoodByBarcode(String barcode) async {
    try {
      final dbHelper = DatabaseHelper();
      return await dbHelper.fetchFoodFromOpenFoodFacts(barcode);
    } catch (e) {
      // Handle error
      print('Error getting food by barcode: $e');
      return null;
    }
  }

  Future<void> setOpenFoodFactsApiKey(String apiKey) async {
    _openFoodFactsApiKey = apiKey;
    final dbHelper = DatabaseHelper();
    await dbHelper.setApiKey(apiKey);
    notifyListeners();
  }
  
  // Method to add a food to the local database
  Future<void> addFood(Food food) async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.insertFood(food);
      
      // Reload foods to include the new one
      await loadFoods();
    } catch (e) {
      // Handle error
      print('Error adding food: $e');
    }
  }
  
  // Method to contribute a food back to the community database
  Future<void> contributeFood(Food food) async {
    // In a real implementation, this would send the food data to a community database
    // For now, we'll just add it to our local database
    await addFood(food);
  }
}