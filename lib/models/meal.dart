class Meal {
  final int id;
  final int foodId;
  final double quantity;
  final DateTime dateTime;
  final String mealType; // Breakfast, Lunch, Dinner, Snack

  Meal({
    required this.id,
    required this.foodId,
    required this.quantity,
    required this.dateTime,
    required this.mealType,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as int,
      foodId: json['food_id'] as int,
      quantity: (json['quantity'] as num).toDouble(),
      dateTime: DateTime.parse(json['date_time'] as String),
      mealType: json['meal_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'food_id': foodId,
      'quantity': quantity,
      'date_time': dateTime.toIso8601String(),
      'meal_type': mealType,
    };
    
    // Only include id if it's not 0 (new record)
    if (id != 0) {
      map['id'] = id;
    }
    
    return map;
  }
}