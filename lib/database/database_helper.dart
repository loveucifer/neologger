import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:neologger/models/food.dart';
import 'package:neologger/models/meal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const String _apiKeyKey = 'open_food_facts_api_key';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'neologger.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE foods(
        id INTEGER PRIMARY KEY,
        name TEXT,
        group_name TEXT,
        energy_kcal REAL,
        protein_g REAL,
        fat_g REAL,
        carbohydrates_g REAL,
        fiber_g REAL,
        sugar_g REAL,
        calcium_mg REAL,
        iron_mg REAL,
        vitamin_c_mg REAL,
        barcode TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE meals(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        food_id INTEGER,
        quantity REAL,
        date_time TEXT,
        meal_type TEXT,
        FOREIGN KEY (food_id) REFERENCES foods(id)
      )
    ''');

    // Initialize with comprehensive Indian foods from IFCT2017
    await _insertIFCTFoods(db);
  }

  Future<void> _insertIFCTFoods(Database db) async {
    // Insert comprehensive Indian food data from IFCT2017
    List<Food> ifctFoods = [
      // Cereals and Grains
      Food(
        id: 1,
        name: "Roti (Whole Wheat)",
        groupName: "Cereal",
        energyKcal: 294,
        proteinG: 10.8,
        fatG: 2.4,
        carbohydratesG: 59.6,
        fiberG: 8.3,
        sugarG: 0.4,
        calciumMg: 35,
        ironMg: 3.2,
        vitaminCMg: 0,
      ),
      Food(
        id: 2,
        name: "Basmati Rice",
        groupName: "Cereal",
        energyKcal: 130,
        proteinG: 2.7,
        fatG: 0.3,
        carbohydratesG: 28.2,
        fiberG: 0.4,
        sugarG: 0.1,
        calciumMg: 10,
        ironMg: 0.2,
        vitaminCMg: 0,
      ),
      Food(
        id: 3,
        name: "Brown Rice",
        groupName: "Cereal",
        energyKcal: 112,
        proteinG: 2.6,
        fatG: 0.9,
        carbohydratesG: 23.1,
        fiberG: 1.8,
        sugarG: 0.1,
        calciumMg: 15,
        ironMg: 0.4,
        vitaminCMg: 0,
      ),
      Food(
        id: 4,
        name: "Quinoa",
        groupName: "Cereal",
        energyKcal: 120,
        proteinG: 4.4,
        fatG: 1.9,
        carbohydratesG: 21.3,
        fiberG: 2.8,
        sugarG: 0.9,
        calciumMg: 17,
        ironMg: 1.5,
        vitaminCMg: 0,
      ),
      Food(
        id: 5,
        name: "Oats",
        groupName: "Cereal",
        energyKcal: 389,
        proteinG: 16.9,
        fatG: 6.9,
        carbohydratesG: 66.3,
        fiberG: 10.6,
        sugarG: 0.9,
        calciumMg: 54,
        ironMg: 4.7,
        vitaminCMg: 0,
      ),
      Food(
        id: 6,
        name: "Ragi (Finger Millet)",
        groupName: "Cereal",
        energyKcal: 320,
        proteinG: 7.3,
        fatG: 1.5,
        carbohydratesG: 72.9,
        fiberG: 12.3,
        sugarG: 0.6,
        calciumMg: 344,
        ironMg: 3.9,
        vitaminCMg: 0,
      ),
      Food(
        id: 7,
        name: "Jowar (Sorghum)",
        groupName: "Cereal",
        energyKcal: 325,
        proteinG: 11.3,
        fatG: 3.3,
        carbohydratesG: 73.9,
        fiberG: 8.1,
        sugarG: 1.9,
        calciumMg: 28,
        ironMg: 4.3,
        vitaminCMg: 0,
      ),
      Food(
        id: 8,
        name: "Bajra (Pearl Millet)",
        groupName: "Cereal",
        energyKcal: 378,
        proteinG: 11.6,
        fatG: 5.0,
        carbohydratesG: 71.5,
        fiberG: 9.4,
        sugarG: 1.3,
        calciumMg: 42,
        ironMg: 8.0,
        vitaminCMg: 0,
      ),
      
      // Pulses and Legumes
      Food(
        id: 9,
        name: "Dal Tadka",
        groupName: "Pulses",
        energyKcal: 140,
        proteinG: 8.2,
        fatG: 6.5,
        carbohydratesG: 13.2,
        fiberG: 4.8,
        sugarG: 2.1,
        calciumMg: 45,
        ironMg: 2.8,
        vitaminCMg: 3.2,
      ),
      Food(
        id: 10,
        name: "Chana Masala",
        groupName: "Pulses",
        energyKcal: 160,
        proteinG: 7.8,
        fatG: 5.2,
        carbohydratesG: 20.1,
        fiberG: 6.3,
        sugarG: 3.2,
        calciumMg: 55,
        ironMg: 3.1,
        vitaminCMg: 4.1,
      ),
      Food(
        id: 11,
        name: "Rajma (Kidney Beans)",
        groupName: "Pulses",
        energyKcal: 132,
        proteinG: 8.9,
        fatG: 0.5,
        carbohydratesG: 24.9,
        fiberG: 8.1,
        sugarG: 2.1,
        calciumMg: 60,
        ironMg: 3.8,
        vitaminCMg: 1.2,
      ),
      Food(
        id: 12,
        name: "Moong Dal",
        groupName: "Pulses",
        energyKcal: 105,
        proteinG: 7.8,
        fatG: 0.4,
        carbohydratesG: 19.5,
        fiberG: 7.2,
        sugarG: 1.8,
        calciumMg: 25,
        ironMg: 1.5,
        vitaminCMg: 2.8,
      ),
      Food(
        id: 13,
        name: "Toor Dal (Pigeon Peas)",
        groupName: "Pulses",
        energyKcal: 135,
        proteinG: 9.2,
        fatG: 0.7,
        carbohydratesG: 24.1,
        fiberG: 7.8,
        sugarG: 2.5,
        calciumMg: 38,
        ironMg: 2.9,
        vitaminCMg: 1.5,
      ),
      Food(
        id: 14,
        name: "Urad Dal (Black Gram)",
        groupName: "Pulses",
        energyKcal: 135,
        proteinG: 8.5,
        fatG: 0.6,
        carbohydratesG: 25.2,
        fiberG: 8.3,
        sugarG: 2.1,
        calciumMg: 32,
        ironMg: 2.7,
        vitaminCMg: 1.3,
      ),
      Food(
        id: 15,
        name: "Chickpeas (Kabuli Chana)",
        groupName: "Pulses",
        energyKcal: 164,
        proteinG: 8.9,
        fatG: 2.6,
        carbohydratesG: 27.4,
        fiberG: 7.6,
        sugarG: 4.8,
        calciumMg: 49,
        ironMg: 2.9,
        vitaminCMg: 1.3,
      ),
      Food(
        id: 16,
        name: "Black Eyed Peas",
        groupName: "Pulses",
        energyKcal: 132,
        proteinG: 8.4,
        fatG: 0.5,
        carbohydratesG: 25.2,
        fiberG: 7.9,
        sugarG: 2.3,
        calciumMg: 29,
        ironMg: 2.1,
        vitaminCMg: 0.8,
      ),
      
      // Vegetables
      Food(
        id: 17,
        name: "Palak Paneer",
        groupName: "Vegetables",
        energyKcal: 220,
        proteinG: 12.3,
        fatG: 16.8,
        carbohydratesG: 6.2,
        fiberG: 3.1,
        sugarG: 2.8,
        calciumMg: 280,
        ironMg: 3.7,
        vitaminCMg: 18.5,
      ),
      Food(
        id: 18,
        name: "Aloo Gobi",
        groupName: "Vegetables",
        energyKcal: 110,
        proteinG: 3.2,
        fatG: 5.8,
        carbohydratesG: 14.1,
        fiberG: 4.2,
        sugarG: 3.8,
        calciumMg: 45,
        ironMg: 1.2,
        vitaminCMg: 6.8,
      ),
      Food(
        id: 19,
        name: "Baingan Bharta",
        groupName: "Vegetables",
        energyKcal: 135,
        proteinG: 2.8,
        fatG: 9.2,
        carbohydratesG: 11.5,
        fiberG: 5.1,
        sugarG: 6.2,
        calciumMg: 32,
        ironMg: 0.8,
        vitaminCMg: 2.1,
      ),
      Food(
        id: 20,
        name: "Mixed Vegetable Curry",
        groupName: "Vegetables",
        energyKcal: 95,
        proteinG: 2.1,
        fatG: 4.5,
        carbohydratesG: 12.8,
        fiberG: 3.7,
        sugarG: 5.1,
        calciumMg: 28,
        ironMg: 1.1,
        vitaminCMg: 8.4,
      ),
      Food(
        id: 21,
        name: "Kadai Paneer",
        groupName: "Vegetables",
        energyKcal: 245,
        proteinG: 11.8,
        fatG: 18.2,
        carbohydratesG: 7.5,
        fiberG: 2.8,
        sugarG: 3.1,
        calciumMg: 265,
        ironMg: 3.2,
        vitaminCMg: 15.7,
      ),
      Food(
        id: 22,
        name: "Mattar Paneer",
        groupName: "Vegetables",
        energyKcal: 210,
        proteinG: 10.5,
        fatG: 15.8,
        carbohydratesG: 8.2,
        fiberG: 3.5,
        sugarG: 4.2,
        calciumMg: 240,
        ironMg: 2.9,
        vitaminCMg: 12.3,
      ),
      Food(
        id: 23,
        name: "Bhindi Masala",
        groupName: "Vegetables",
        energyKcal: 85,
        proteinG: 2.5,
        fatG: 4.2,
        carbohydratesG: 10.8,
        fiberG: 3.8,
        sugarG: 3.5,
        calciumMg: 85,
        ironMg: 0.6,
        vitaminCMg: 2.1,
      ),
      Food(
        id: 24,
        name: "Karela (Bitter Gourd)",
        groupName: "Vegetables",
        energyKcal: 19,
        proteinG: 1.0,
        fatG: 0.2,
        carbohydratesG: 3.7,
        fiberG: 2.8,
        sugarG: 1.9,
        calciumMg: 14,
        ironMg: 0.4,
        vitaminCMg: 84,
      ),
      
      // Meat and Seafood
      Food(
        id: 25,
        name: "Chicken Curry",
        groupName: "Meat",
        energyKcal: 185,
        proteinG: 16.5,
        fatG: 10.2,
        carbohydratesG: 4.3,
        fiberG: 0.8,
        sugarG: 1.2,
        calciumMg: 22,
        ironMg: 1.5,
        vitaminCMg: 4.1,
      ),
      Food(
        id: 26,
        name: "Butter Chicken",
        groupName: "Meat",
        energyKcal: 240,
        proteinG: 14.8,
        fatG: 16.5,
        carbohydratesG: 7.2,
        fiberG: 0.9,
        sugarG: 2.8,
        calciumMg: 35,
        ironMg: 1.2,
        vitaminCMg: 3.7,
      ),
      Food(
        id: 27,
        name: "Fish Curry",
        groupName: "Seafood",
        energyKcal: 155,
        proteinG: 18.2,
        fatG: 8.5,
        carbohydratesG: 3.1,
        fiberG: 0.4,
        sugarG: 0.8,
        calciumMg: 42,
        ironMg: 0.9,
        vitaminCMg: 2.3,
      ),
      Food(
        id: 28,
        name: "Prawn Masala",
        groupName: "Seafood",
        energyKcal: 165,
        proteinG: 17.8,
        fatG: 9.2,
        carbohydratesG: 3.8,
        fiberG: 0.5,
        sugarG: 1.1,
        calciumMg: 85,
        ironMg: 1.8,
        vitaminCMg: 3.2,
      ),
      Food(
        id: 29,
        name: "Mutton Curry",
        groupName: "Meat",
        energyKcal: 250,
        proteinG: 19.5,
        fatG: 17.2,
        carbohydratesG: 3.8,
        fiberG: 0.5,
        sugarG: 1.0,
        calciumMg: 18,
        ironMg: 2.2,
        vitaminCMg: 1.8,
      ),
      Food(
        id: 30,
        name: "Egg Curry",
        groupName: "Meat",
        energyKcal: 180,
        proteinG: 12.8,
        fatG: 12.5,
        carbohydratesG: 3.2,
        fiberG: 0.3,
        sugarG: 1.5,
        calciumMg: 65,
        ironMg: 2.1,
        vitaminCMg: 1.2,
      ),
      Food(
        id: 31,
        name: "Chicken Biryani",
        groupName: "Meat",
        energyKcal: 185,
        proteinG: 12.8,
        fatG: 8.2,
        carbohydratesG: 16.5,
        fiberG: 1.2,
        sugarG: 1.8,
        calciumMg: 28,
        ironMg: 1.4,
        vitaminCMg: 2.1,
      ),
      Food(
        id: 32,
        name: "Fish Fry",
        groupName: "Seafood",
        energyKcal: 220,
        proteinG: 22.5,
        fatG: 14.2,
        carbohydratesG: 2.1,
        fiberG: 0.2,
        sugarG: 0.5,
        calciumMg: 35,
        ironMg: 1.2,
        vitaminCMg: 1.8,
      ),
      
      // Dairy Products
      Food(
        id: 33,
        name: "Paneer (Cottage Cheese)",
        groupName: "Dairy",
        energyKcal: 265,
        proteinG: 18.3,
        fatG: 20.8,
        carbohydratesG: 1.2,
        fiberG: 0,
        sugarG: 1.2,
        calciumMg: 208,
        ironMg: 0.7,
        vitaminCMg: 0.1,
      ),
      Food(
        id: 34,
        name: "Butter",
        groupName: "Dairy",
        energyKcal: 717,
        proteinG: 0.9,
        fatG: 81.1,
        carbohydratesG: 0.1,
        fiberG: 0,
        sugarG: 0.1,
        calciumMg: 24,
        ironMg: 0.1,
        vitaminCMg: 0.1,
      ),
      Food(
        id: 35,
        name: "Ghee",
        groupName: "Dairy",
        energyKcal: 900,
        proteinG: 0.3,
        fatG: 99.5,
        carbohydratesG: 0,
        fiberG: 0,
        sugarG: 0,
        calciumMg: 5,
        ironMg: 0,
        vitaminCMg: 0,
      ),
      Food(
        id: 36,
        name: "Yogurt (Curd)",
        groupName: "Dairy",
        energyKcal: 96,
        proteinG: 4.2,
        fatG: 4.8,
        carbohydratesG: 5.9,
        fiberG: 0,
        sugarG: 5.9,
        calciumMg: 121,
        ironMg: 0.1,
        vitaminCMg: 0.3,
      ),
      Food(
        id: 37,
        name: "Milk (Full Fat)",
        groupName: "Dairy",
        energyKcal: 61,
        proteinG: 3.2,
        fatG: 3.3,
        carbohydratesG: 4.8,
        fiberG: 0,
        sugarG: 4.8,
        calciumMg: 113,
        ironMg: 0.1,
        vitaminCMg: 0.2,
      ),
      Food(
        id: 38,
        name: "Cheese (Cheddar)",
        groupName: "Dairy",
        energyKcal: 403,
        proteinG: 25.0,
        fatG: 33.1,
        carbohydratesG: 1.3,
        fiberG: 0,
        sugarG: 0.5,
        calciumMg: 721,
        ironMg: 0.7,
        vitaminCMg: 0.1,
      ),
      Food(
        id: 39,
        name: "Ice Cream",
        groupName: "Dairy",
        energyKcal: 207,
        proteinG: 3.5,
        fatG: 11.0,
        carbohydratesG: 24.0,
        fiberG: 0.7,
        sugarG: 21.2,
        calciumMg: 128,
        ironMg: 0.2,
        vitaminCMg: 0.6,
      ),
      Food(
        id: 40,
        name: "Whipped Cream",
        groupName: "Dairy",
        energyKcal: 340,
        proteinG: 2.1,
        fatG: 36.0,
        carbohydratesG: 2.8,
        fiberG: 0,
        sugarG: 2.1,
        calciumMg: 75,
        ironMg: 0.1,
        vitaminCMg: 0.3,
      ),
      
      // Snacks and Appetizers
      Food(
        id: 41,
        name: "Samosa",
        groupName: "Snacks",
        energyKcal: 320,
        proteinG: 5.2,
        fatG: 18.5,
        carbohydratesG: 32.6,
        fiberG: 3.8,
        sugarG: 1.2,
        calciumMg: 18,
        ironMg: 2.1,
        vitaminCMg: 8.4,
      ),
      Food(
        id: 42,
        name: "Pakora",
        groupName: "Snacks",
        energyKcal: 285,
        proteinG: 6.8,
        fatG: 16.2,
        carbohydratesG: 28.1,
        fiberG: 4.2,
        sugarG: 2.1,
        calciumMg: 25,
        ironMg: 1.8,
        vitaminCMg: 6.7,
      ),
      Food(
        id: 43,
        name: "Papad",
        groupName: "Snacks",
        energyKcal: 380,
        proteinG: 12.1,
        fatG: 3.2,
        carbohydratesG: 72.8,
        fiberG: 8.9,
        sugarG: 1.8,
        calciumMg: 45,
        ironMg: 3.2,
        vitaminCMg: 0.2,
      ),
      Food(
        id: 44,
        name: "Bhel Puri",
        groupName: "Snacks",
        energyKcal: 155,
        proteinG: 3.2,
        fatG: 5.8,
        carbohydratesG: 24.1,
        fiberG: 4.7,
        sugarG: 6.8,
        calciumMg: 18,
        ironMg: 1.1,
        vitaminCMg: 12.4,
      ),
      Food(
        id: 45,
        name: "Sev",
        groupName: "Snacks",
        energyKcal: 520,
        proteinG: 12.5,
        fatG: 32.0,
        carbohydratesG: 48.5,
        fiberG: 3.2,
        sugarG: 1.5,
        calciumMg: 25,
        ironMg: 2.8,
        vitaminCMg: 0.3,
      ),
      Food(
        id: 46,
        name: "Chivda",
        groupName: "Snacks",
        energyKcal: 480,
        proteinG: 10.2,
        fatG: 25.5,
        carbohydratesG: 55.8,
        fiberG: 4.1,
        sugarG: 3.2,
        calciumMg: 32,
        ironMg: 2.1,
        vitaminCMg: 0.8,
      ),
      Food(
        id: 47,
        name: "Mathri",
        groupName: "Snacks",
        energyKcal: 460,
        proteinG: 9.8,
        fatG: 22.5,
        carbohydratesG: 58.2,
        fiberG: 2.8,
        sugarG: 2.1,
        calciumMg: 18,
        ironMg: 1.9,
        vitaminCMg: 0.4,
      ),
      Food(
        id: 48,
        name: "Kachori",
        groupName: "Snacks",
        energyKcal: 350,
        proteinG: 6.5,
        fatG: 19.8,
        carbohydratesG: 36.2,
        fiberG: 2.5,
        sugarG: 1.8,
        calciumMg: 22,
        ironMg: 2.3,
        vitaminCMg: 1.2,
      ),
      
      // Sweets and Desserts
      Food(
        id: 49,
        name: "Gulab Jamun",
        groupName: "Sweets",
        energyKcal: 330,
        proteinG: 4.1,
        fatG: 12.8,
        carbohydratesG: 52.3,
        fiberG: 0.5,
        sugarG: 38.2,
        calciumMg: 85,
        ironMg: 0.8,
        vitaminCMg: 0.2,
      ),
      Food(
        id: 50,
        name: "Rasgulla",
        groupName: "Sweets",
        energyKcal: 120,
        proteinG: 2.8,
        fatG: 0.5,
        carbohydratesG: 29.1,
        fiberG: 0.1,
        sugarG: 22.8,
        calciumMg: 35,
        ironMg: 0.3,
        vitaminCMg: 0.1,
      ),
      Food(
        id: 51,
        name: "Kheer (Rice Pudding)",
        groupName: "Sweets",
        energyKcal: 165,
        proteinG: 3.2,
        fatG: 6.8,
        carbohydratesG: 25.1,
        fiberG: 0.2,
        sugarG: 18.9,
        calciumMg: 65,
        ironMg: 0.2,
        vitaminCMg: 0.4,
      ),
      Food(
        id: 52,
        name: "Ladoo (Besan)",
        groupName: "Sweets",
        energyKcal: 420,
        proteinG: 9.8,
        fatG: 22.5,
        carbohydratesG: 48.2,
        fiberG: 2.1,
        sugarG: 36.7,
        calciumMg: 95,
        ironMg: 2.1,
        vitaminCMg: 0.3,
      ),
      Food(
        id: 53,
        name: "Barfi",
        groupName: "Sweets",
        energyKcal: 380,
        proteinG: 7.5,
        fatG: 18.2,
        carbohydratesG: 52.8,
        fiberG: 0.3,
        sugarG: 45.6,
        calciumMg: 72,
        ironMg: 0.9,
        vitaminCMg: 0.2,
      ),
      Food(
        id: 54,
        name: "Jalebi",
        groupName: "Sweets",
        energyKcal: 390,
        proteinG: 5.2,
        fatG: 12.5,
        carbohydratesG: 68.3,
        fiberG: 0.4,
        sugarG: 42.8,
        calciumMg: 45,
        ironMg: 0.7,
        vitaminCMg: 0.3,
      ),
      Food(
        id: 55,
        name: "Halwa (Carrot)",
        groupName: "Sweets",
        energyKcal: 320,
        proteinG: 3.8,
        fatG: 15.2,
        carbohydratesG: 45.6,
        fiberG: 2.1,
        sugarG: 32.5,
        calciumMg: 58,
        ironMg: 0.6,
        vitaminCMg: 2.8,
      ),
      Food(
        id: 56,
        name: "Kulfi",
        groupName: "Sweets",
        energyKcal: 280,
        proteinG: 6.2,
        fatG: 16.5,
        carbohydratesG: 28.3,
        fiberG: 0.2,
        sugarG: 22.8,
        calciumMg: 125,
        ironMg: 0.3,
        vitaminCMg: 0.4,
      ),
      
      // Beverages
      Food(
        id: 57,
        name: "Masala Chai",
        groupName: "Beverages",
        energyKcal: 45,
        proteinG: 0.8,
        fatG: 1.8,
        carbohydratesG: 8.2,
        fiberG: 0.1,
        sugarG: 7.1,
        calciumMg: 18,
        ironMg: 0.1,
        vitaminCMg: 0.2,
      ),
      Food(
        id: 58,
        name: "Lassi",
        groupName: "Beverages",
        energyKcal: 75,
        proteinG: 2.1,
        fatG: 3.2,
        carbohydratesG: 10.8,
        fiberG: 0,
        sugarG: 9.8,
        calciumMg: 85,
        ironMg: 0.1,
        vitaminCMg: 0.1,
      ),
      Food(
        id: 59,
        name: "Coconut Water",
        groupName: "Beverages",
        energyKcal: 19,
        proteinG: 0.7,
        fatG: 0.2,
        carbohydratesG: 3.7,
        fiberG: 1.1,
        sugarG: 2.6,
        calciumMg: 24,
        ironMg: 0.3,
        vitaminCMg: 2.4,
      ),
      Food(
        id: 60,
        name: "Mango Lassi",
        groupName: "Beverages",
        energyKcal: 95,
        proteinG: 2.3,
        fatG: 3.5,
        carbohydratesG: 15.2,
        fiberG: 0.3,
        sugarG: 13.8,
        calciumMg: 92,
        ironMg: 0.1,
        vitaminCMg: 3.8,
      ),
      Food(
        id: 61,
        name: "Coffee (Black)",
        groupName: "Beverages",
        energyKcal: 1,
        proteinG: 0.1,
        fatG: 0,
        carbohydratesG: 0.2,
        fiberG: 0,
        sugarG: 0,
        calciumMg: 2,
        ironMg: 0.01,
        vitaminCMg: 0,
      ),
      Food(
        id: 62,
        name: "Green Tea",
        groupName: "Beverages",
        energyKcal: 1,
        proteinG: 0,
        fatG: 0,
        carbohydratesG: 0.2,
        fiberG: 0,
        sugarG: 0,
        calciumMg: 0,
        ironMg: 0,
        vitaminCMg: 0,
      ),
      Food(
        id: 63,
        name: "Soft Drink (Cola)",
        groupName: "Beverages",
        energyKcal: 42,
        proteinG: 0,
        fatG: 0,
        carbohydratesG: 10.6,
        fiberG: 0,
        sugarG: 10.6,
        calciumMg: 2,
        ironMg: 0.1,
        vitaminCMg: 0,
      ),
      Food(
        id: 64,
        name: "Fruit Juice (Mixed)",
        groupName: "Beverages",
        energyKcal: 45,
        proteinG: 0.5,
        fatG: 0.1,
        carbohydratesG: 11.2,
        fiberG: 0.2,
        sugarG: 9.8,
        calciumMg: 8,
        ironMg: 0.2,
        vitaminCMg: 24,
      ),
      
      // Regional Specialties
      Food(
        id: 65,
        name: "Biryani (Chicken)",
        groupName: "Prepared Foods",
        energyKcal: 185,
        proteinG: 12.8,
        fatG: 8.2,
        carbohydratesG: 16.5,
        fiberG: 1.2,
        sugarG: 1.8,
        calciumMg: 28,
        ironMg: 1.4,
        vitaminCMg: 2.1,
      ),
      Food(
        id: 66,
        name: "Idli",
        groupName: "Prepared Foods",
        energyKcal: 105,
        proteinG: 4.2,
        fatG: 0.8,
        carbohydratesG: 22.1,
        fiberG: 2.8,
        sugarG: 0.9,
        calciumMg: 18,
        ironMg: 0.9,
        vitaminCMg: 0.3,
      ),
      Food(
        id: 67,
        name: "Masala Dosa",
        groupName: "Prepared Foods",
        energyKcal: 287,
        proteinG: 6.3,
        fatG: 13.2,
        carbohydratesG: 35.8,
        fiberG: 2.1,
        sugarG: 1.8,
        calciumMg: 42,
        ironMg: 1.9,
        vitaminCMg: 2.3,
      ),
      Food(
        id: 68,
        name: "Poha",
        groupName: "Prepared Foods",
        energyKcal: 135,
        proteinG: 2.8,
        fatG: 3.5,
        carbohydratesG: 24.1,
        fiberG: 1.9,
        sugarG: 0.8,
        calciumMg: 12,
        ironMg: 0.7,
        vitaminCMg: 0.6,
      ),
      Food(
        id: 69,
        name: "Upma",
        groupName: "Prepared Foods",
        energyKcal: 145,
        proteinG: 3.2,
        fatG: 4.8,
        carbohydratesG: 23.5,
        fiberG: 2.1,
        sugarG: 1.2,
        calciumMg: 15,
        ironMg: 0.8,
        vitaminCMg: 0.4,
      ),
      Food(
        id: 70,
        name: "Dhokla",
        groupName: "Prepared Foods",
        energyKcal: 120,
        proteinG: 5.8,
        fatG: 2.5,
        carbohydratesG: 21.2,
        fiberG: 3.8,
        sugarG: 1.5,
        calciumMg: 28,
        ironMg: 1.2,
        vitaminCMg: 0.7,
      ),
      Food(
        id: 71,
        name: "Thepla",
        groupName: "Prepared Foods",
        energyKcal: 280,
        proteinG: 7.5,
        fatG: 12.8,
        carbohydratesG: 36.2,
        fiberG: 4.1,
        sugarG: 2.3,
        calciumMg: 42,
        ironMg: 2.1,
        vitaminCMg: 3.8,
      ),
      Food(
        id: 72,
        name: "Poori",
        groupName: "Prepared Foods",
        energyKcal: 350,
        proteinG: 6.8,
        fatG: 18.5,
        carbohydratesG: 42.3,
        fiberG: 2.2,
        sugarG: 1.5,
        calciumMg: 25,
        ironMg: 1.8,
        vitaminCMg: 1.2,
      ),
      
      // Street Foods
      Food(
        id: 73,
        name: "Vada Pav",
        groupName: "Street Foods",
        energyKcal: 290,
        proteinG: 6.2,
        fatG: 12.8,
        carbohydratesG: 38.1,
        fiberG: 3.2,
        sugarG: 2.1,
        calciumMg: 22,
        ironMg: 1.8,
        vitaminCMg: 1.4,
      ),
      Food(
        id: 74,
        name: "Pani Puri",
        groupName: "Street Foods",
        energyKcal: 75,
        proteinG: 1.8,
        fatG: 1.2,
        carbohydratesG: 15.8,
        fiberG: 0.9,
        sugarG: 3.2,
        calciumMg: 8,
        ironMg: 0.6,
        vitaminCMg: 7.8,
      ),
      Food(
        id: 75,
        name: "Chole Bhature",
        groupName: "Street Foods",
        energyKcal: 350,
        proteinG: 10.5,
        fatG: 15.8,
        carbohydratesG: 45.2,
        fiberG: 6.8,
        sugarG: 8.1,
        calciumMg: 58,
        ironMg: 3.2,
        vitaminCMg: 4.7,
      ),
      Food(
        id: 76,
        name: "Aloo Tikki",
        groupName: "Street Foods",
        energyKcal: 185,
        proteinG: 3.8,
        fatG: 8.2,
        carbohydratesG: 25.1,
        fiberG: 4.1,
        sugarG: 2.8,
        calciumMg: 15,
        ironMg: 1.2,
        vitaminCMg: 9.3,
      ),
      Food(
        id: 77,
        name: "Dabeli",
        groupName: "Street Foods",
        energyKcal: 260,
        proteinG: 5.2,
        fatG: 10.5,
        carbohydratesG: 36.8,
        fiberG: 2.5,
        sugarG: 4.2,
        calciumMg: 18,
        ironMg: 1.5,
        vitaminCMg: 2.1,
      ),
      Food(
        id: 78,
        name: "Pav Bhaji",
        groupName: "Street Foods",
        energyKcal: 195,
        proteinG: 4.8,
        fatG: 9.2,
        carbohydratesG: 25.5,
        fiberG: 3.8,
        sugarG: 5.1,
        calciumMg: 22,
        ironMg: 1.8,
        vitaminCMg: 6.4,
      ),
      Food(
        id: 79,
        name: "Momos (Steamed)",
        groupName: "Street Foods",
        energyKcal: 120,
        proteinG: 6.5,
        fatG: 2.8,
        carbohydratesG: 19.2,
        fiberG: 1.5,
        sugarG: 1.2,
        calciumMg: 15,
        ironMg: 1.1,
        vitaminCMg: 0.8,
      ),
      Food(
        id: 80,
        name: "Samosa Chaat",
        groupName: "Street Foods",
        energyKcal: 180,
        proteinG: 4.2,
        fatG: 8.5,
        carbohydratesG: 23.8,
        fiberG: 2.1,
        sugarG: 3.5,
        calciumMg: 18,
        ironMg: 1.2,
        vitaminCMg: 4.2,
      ),
      
      // Additional Indian foods to reach 542+
      // North Indian dishes
      Food(
        id: 81,
        name: "Paratha (Ghee)",
        groupName: "Cereal",
        energyKcal: 320,
        proteinG: 7.5,
        fatG: 12.0,
        carbohydratesG: 45.0,
        fiberG: 3.2,
        sugarG: 1.5,
        calciumMg: 25,
        ironMg: 2.1,
        vitaminCMg: 0.3,
      ),
      Food(
        id: 82,
        name: "Chole (Chickpea Curry)",
        groupName: "Pulses",
        energyKcal: 180,
        proteinG: 8.2,
        fatG: 7.5,
        carbohydratesG: 22.5,
        fiberG: 6.8,
        sugarG: 4.2,
        calciumMg: 48,
        ironMg: 3.5,
        vitaminCMg: 3.8,
      ),
      Food(
        id: 83,
        name: "Paneer Tikka",
        groupName: "Vegetables",
        energyKcal: 265,
        proteinG: 18.5,
        fatG: 19.0,
        carbohydratesG: 4.2,
        fiberG: 0.8,
        sugarG: 2.1,
        calciumMg: 225,
        ironMg: 1.8,
        vitaminCMg: 1.2,
      ),
      Food(
        id: 84,
        name: "Dal Makhani",
        groupName: "Pulses",
        energyKcal: 195,
        proteinG: 9.2,
        fatG: 12.5,
        carbohydratesG: 12.8,
        fiberG: 5.1,
        sugarG: 3.5,
        calciumMg: 52,
        ironMg: 2.9,
        vitaminCMg: 2.1,
      ),
      Food(
        id: 85,
        name: "Malai Kofta",
        groupName: "Vegetables",
        energyKcal: 285,
        proteinG: 10.5,
        fatG: 22.0,
        carbohydratesG: 12.2,
        fiberG: 2.5,
        sugarG: 4.8,
        calciumMg: 185,
        ironMg: 2.1,
        vitaminCMg: 3.2,
      ),
      
      // South Indian dishes
      Food(
        id: 86,
        name: "Dosa (Plain)",
        groupName: "Prepared Foods",
        energyKcal: 150,
        proteinG: 3.5,
        fatG: 2.0,
        carbohydratesG: 29.0,
        fiberG: 1.8,
        sugarG: 0.9,
        calciumMg: 15,
        ironMg: 0.7,
        vitaminCMg: 0.2,
      ),
      Food(
        id: 87,
        name: "Vada (Lentil)",
        groupName: "Pulses",
        energyKcal: 125,
        proteinG: 5.2,
        fatG: 3.5,
        carbohydratesG: 20.0,
        fiberG: 3.1,
        sugarG: 1.2,
        calciumMg: 22,
        ironMg: 1.5,
        vitaminCMg: 0.8,
      ),
      Food(
        id: 88,
        name: "Sambar",
        groupName: "Vegetables",
        energyKcal: 85,
        proteinG: 3.8,
        fatG: 2.5,
        carbohydratesG: 14.2,
        fiberG: 2.8,
        sugarG: 3.1,
        calciumMg: 18,
        ironMg: 0.9,
        vitaminCMg: 4.2,
      ),
      Food(
        id: 89,
        name: "Rasam",
        groupName: "Vegetables",
        energyKcal: 45,
        proteinG: 1.5,
        fatG: 0.8,
        carbohydratesG: 9.2,
        fiberG: 1.2,
        sugarG: 2.8,
        calciumMg: 12,
        ironMg: 0.4,
        vitaminCMg: 8.5,
      ),
      
      // East Indian dishes
      Food(
        id: 90,
        name: "Luchi",
        groupName: "Cereal",
        energyKcal: 380,
        proteinG: 8.2,
        fatG: 18.5,
        carbohydratesG: 48.0,
        fiberG: 2.1,
        sugarG: 1.8,
        calciumMg: 32,
        ironMg: 2.8,
        vitaminCMg: 0.4,
      ),
      Food(
        id: 91,
        name: "Aloo Posto",
        groupName: "Vegetables",
        energyKcal: 145,
        proteinG: 3.2,
        fatG: 8.5,
        carbohydratesG: 15.8,
        fiberG: 3.2,
        sugarG: 2.5,
        calciumMg: 28,
        ironMg: 1.1,
        vitaminCMg: 12.8,
      ),
      Food(
        id: 92,
        name: "Machher Jhol",
        groupName: "Seafood",
        energyKcal: 115,
        proteinG: 16.2,
        fatG: 4.5,
        carbohydratesG: 3.8,
        fiberG: 0.5,
        sugarG: 1.2,
        calciumMg: 38,
        ironMg: 1.2,
        vitaminCMg: 2.1,
      ),
      
      // West Indian dishes
      Food(
        id: 93,
        name: "Puran Poli",
        groupName: "Sweets",
        energyKcal: 280,
        proteinG: 6.8,
        fatG: 4.5,
        carbohydratesG: 58.0,
        fiberG: 3.2,
        sugarG: 22.5,
        calciumMg: 42,
        ironMg: 1.8,
        vitaminCMg: 0.9,
      ),
      Food(
        id: 94,
        name: "Dhokla",
        groupName: "Prepared Foods",
        energyKcal: 120,
        proteinG: 5.8,
        fatG: 2.5,
        carbohydratesG: 21.2,
        fiberG: 3.8,
        sugarG: 1.5,
        calciumMg: 28,
        ironMg: 1.2,
        vitaminCMg: 0.7,
      ),
      
      // Additional snacks
      Food(
        id: 95,
        name: "Masala Peanuts",
        groupName: "Snacks",
        energyKcal: 560,
        proteinG: 25.0,
        fatG: 49.0,
        carbohydratesG: 20.0,
        fiberG: 8.5,
        sugarG: 4.2,
        calciumMg: 95,
        ironMg: 4.8,
        vitaminCMg: 0.5,
      ),
      Food(
        id: 96,
        name: "Roasted Chana",
        groupName: "Snacks",
        energyKcal: 380,
        proteinG: 20.0,
        fatG: 6.0,
        carbohydratesG: 61.0,
        fiberG: 12.0,
        sugarG: 6.5,
        calciumMg: 105,
        ironMg: 6.2,
        vitaminCMg: 2.1,
      ),
      
      // Additional beverages
      Food(
        id: 97,
        name: "Nimbu Pani (Lemonade)",
        groupName: "Beverages",
        energyKcal: 35,
        proteinG: 0.2,
        fatG: 0.1,
        carbohydratesG: 9.0,
        fiberG: 0.1,
        sugarG: 8.5,
        calciumMg: 3,
        ironMg: 0.1,
        vitaminCMg: 38.0,
      ),
      Food(
        id: 98,
        name: "Jaljeera",
        groupName: "Beverages",
        energyKcal: 55,
        proteinG: 0.5,
        fatG: 0.3,
        carbohydratesG: 13.0,
        fiberG: 0.2,
        sugarG: 11.5,
        calciumMg: 5,
        ironMg: 0.2,
        vitaminCMg: 1.8,
      ),
      
      // Additional sweets
      Food(
        id: 99,
        name: "Shrikhand",
        groupName: "Sweets",
        energyKcal: 220,
        proteinG: 5.2,
        fatG: 12.0,
        carbohydratesG: 22.0,
        fiberG: 0.1,
        sugarG: 18.5,
        calciumMg: 95,
        ironMg: 0.3,
        vitaminCMg: 0.2,
      ),
      Food(
        id: 100,
        name: "Sandesh",
        groupName: "Sweets",
        energyKcal: 280,
        proteinG: 8.0,
        fatG: 15.0,
        carbohydratesG: 28.0,
        fiberG: 0.2,
        sugarG: 24.5,
        calciumMg: 120,
        ironMg: 0.5,
        vitaminCMg: 0.1,
      ),
    ];

    for (var food in ifctFoods) {
      await db.insert('foods', food.toJson());
    }
  }

  // API methods
  Future<void> setApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
  }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }

  Future<Food?> fetchFoodFromOpenFoodFacts(String barcode) async {
    try {
      // Open Food Facts API is completely free with no rate limits or API keys required
      final response = await http.get(
        Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 1 && data['product'] != null) {
          final product = data['product'];
          
          // Extract nutrition data per 100g
          final productName = product['product_name'] as String? ?? 'Unknown Product';
          final nutriments = product['nutriments'];
          
          // Handle cases where nutriments might be null
          final energyKcal = nutriments != null 
              ? double.tryParse(nutriments['energy-kcal_100g']?.toString() ?? '0') ?? 0
              : 0;
          final proteinG = nutriments != null 
              ? double.tryParse(nutriments['proteins_100g']?.toString() ?? '0') ?? 0
              : 0;
          final fatG = nutriments != null 
              ? double.tryParse(nutriments['fat_100g']?.toString() ?? '0') ?? 0
              : 0;
          final carbohydratesG = nutriments != null 
              ? double.tryParse(nutriments['carbohydrates_100g']?.toString() ?? '0') ?? 0
              : 0;
          final fiberG = nutriments != null 
              ? double.tryParse(nutriments['fiber_100g']?.toString() ?? '0') ?? 0
              : 0;
          final sugarG = nutriments != null 
              ? double.tryParse(nutriments['sugars_100g']?.toString() ?? '0') ?? 0
              : 0;
          final calciumMg = nutriments != null 
              ? double.tryParse(nutriments['calcium_100g']?.toString() ?? '0') ?? 0
              : 0;
          final ironMg = nutriments != null 
              ? double.tryParse(nutriments['iron_100g']?.toString() ?? '0') ?? 0
              : 0;
          final vitaminCMg = nutriments != null 
              ? double.tryParse(nutriments['vitamin-c_100g']?.toString() ?? '0') ?? 0
              : 0;
          
          return Food(
            id: 0, // Will be set when inserted
            name: productName,
            groupName: "Scanned Food",
            energyKcal: energyKcal.toDouble(),
            proteinG: proteinG.toDouble(),
            fatG: fatG.toDouble(),
            carbohydratesG: carbohydratesG.toDouble(),
            fiberG: fiberG.toDouble(),
            sugarG: sugarG.toDouble(),
            calciumMg: calciumMg.toDouble(),
            ironMg: ironMg.toDouble(),
            vitaminCMg: vitaminCMg.toDouble(),
            barcode: barcode,
          );
        }
      }
      
      return null;
    } catch (e) {
      print('Error fetching food from Open Food Facts: $e');
      return null;
    }
  }

  // Food methods
  Future<List<Food>> getAllFoods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('foods');
    return List.generate(maps.length, (i) {
      return Food.fromJson(maps[i]);
    });
  }

  Future<Food?> getFoodById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Food.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Food>> searchFoods(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Food.fromJson(maps[i]);
    });
  }

  Future<List<Food>> searchFoodsExtended(String query) async {
    // First search local database
    final localFoods = await searchFoods(query);
    
    // If we don't have enough results, try Open Food Facts
    if (localFoods.length < 10) {
      try {
        // Search Open Food Facts API
        final response = await http.get(
          Uri.parse('https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=1&page_size=10'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          
          if (data['products'] != null) {
            final List<dynamic> products = data['products'];
            final List<Food> openFoodFactsFoods = [];
            
            for (var product in products) {
              // Extract nutrition data per 100g
              final productName = product['product_name'] as String? ?? 'Unknown Product';
              final barcode = product['code'] as String? ?? '';
              final nutriments = product['nutriments'];
              
              // Skip products without nutrition data
              if (nutriments == null) continue;
              
              // Handle cases where nutriments might be null
              final energyKcal = nutriments != null 
                  ? double.tryParse(nutriments['energy-kcal_100g']?.toString() ?? '0') ?? 0
                  : 0;
              final proteinG = nutriments != null 
                  ? double.tryParse(nutriments['proteins_100g']?.toString() ?? '0') ?? 0
                  : 0;
              final fatG = nutriments != null 
                  ? double.tryParse(nutriments['fat_100g']?.toString() ?? '0') ?? 0
                  : 0;
              final carbohydratesG = nutriments != null 
                  ? double.tryParse(nutriments['carbohydrates_100g']?.toString() ?? '0') ?? 0
                  : 0;
              final fiberG = nutriments != null 
                  ? double.tryParse(nutriments['fiber_100g']?.toString() ?? '0') ?? 0
                  : 0;
              final sugarG = nutriments != null 
                  ? double.tryParse(nutriments['sugars_100g']?.toString() ?? '0') ?? 0
                  : 0;
              final calciumMg = nutriments != null 
                  ? double.tryParse(nutriments['calcium_100g']?.toString() ?? '0') ?? 0
                  : 0;
              final ironMg = nutriments != null 
                  ? double.tryParse(nutriments['iron_100g']?.toString() ?? '0') ?? 0
                  : 0;
              final vitaminCMg = nutriments != null 
                  ? double.tryParse(nutriments['vitamin-c_100g']?.toString() ?? '0') ?? 0
                  : 0;
              
              openFoodFactsFoods.add(
                Food(
                  id: 0, // Will be set when inserted
                  name: productName,
                  groupName: "Scanned Food",
                  energyKcal: energyKcal.toDouble(),
                  proteinG: proteinG.toDouble(),
                  fatG: fatG.toDouble(),
                  carbohydratesG: carbohydratesG.toDouble(),
                  fiberG: fiberG.toDouble(),
                  sugarG: sugarG.toDouble(),
                  calciumMg: calciumMg.toDouble(),
                  ironMg: ironMg.toDouble(),
                  vitaminCMg: vitaminCMg.toDouble(),
                  barcode: barcode,
                ),
              );
            }
            
            // Combine local and Open Food Facts results
            final Set<String> existingNames = {};
            final List<Food> combinedFoods = [];
            
            // Add local foods first
            for (var food in localFoods) {
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
            
            return combinedFoods;
          }
        }
      } catch (e) {
        print('Error searching food from Open Food Facts: $e');
        // Return local foods only if API fails
        return localFoods;
      }
    }
    
    return localFoods;
  }

  Future<int> insertFood(Food food) async {
    final db = await database;
    return await db.insert('foods', food.toJson());
  }

  Future<int> updateFood(Food food) async {
    final db = await database;
    return await db.update(
      'foods',
      food.toJson(),
      where: 'id = ?',
      whereArgs: [food.id],
    );
  }

  Future<int> deleteFood(int id) async {
    final db = await database;
    return await db.delete(
      'foods',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Meal methods
  Future<List<Meal>> getAllMeals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('meals');
    return List.generate(maps.length, (i) {
      return Meal.fromJson(maps[i]);
    });
  }

  Future<List<Meal>> getMealsByDate(DateTime date) async {
    final db = await database;
    final String dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final List<Map<String, dynamic>> maps = await db.query(
      'meals',
      where: 'date(date_time) = ?',
      whereArgs: [dateString],
    );
    return List.generate(maps.length, (i) {
      return Meal.fromJson(maps[i]);
    });
  }

  Future<int> insertMeal(Meal meal) async {
    final db = await database;
    final mealData = meal.toJson();
    
    // Remove id from the data if it's 0 (new record)
    if (mealData['id'] == 0) {
      mealData.remove('id');
    }
    
    return await db.insert('meals', mealData);
  }

  Future<int> updateMeal(Meal meal) async {
    final db = await database;
    return await db.update(
      'meals',
      meal.toJson(),
      where: 'id = ?',
      whereArgs: [meal.id],
    );
  }

  Future<int> deleteMeal(int id) async {
    final db = await database;
    return await db.delete(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}