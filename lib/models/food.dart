class Food {
  final int id;
  final String name;
  final String groupName;
  final double energyKcal;
  final double proteinG;
  final double fatG;
  final double carbohydratesG;
  final double fiberG;
  final double sugarG;
  final double calciumMg;
  final double ironMg;
  final double vitaminCMg;
  final String? barcode;

  Food({
    required this.id,
    required this.name,
    required this.groupName,
    required this.energyKcal,
    required this.proteinG,
    required this.fatG,
    required this.carbohydratesG,
    required this.fiberG,
    required this.sugarG,
    required this.calciumMg,
    required this.ironMg,
    required this.vitaminCMg,
    this.barcode,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as int,
      name: json['name'] as String,
      groupName: json['group_name'] as String,
      energyKcal: (json['energy_kcal'] as num).toDouble(),
      proteinG: (json['protein_g'] as num).toDouble(),
      fatG: (json['fat_g'] as num).toDouble(),
      carbohydratesG: (json['carbohydrates_g'] as num).toDouble(),
      fiberG: (json['fiber_g'] as num).toDouble(),
      sugarG: (json['sugar_g'] as num).toDouble(),
      calciumMg: (json['calcium_mg'] as num).toDouble(),
      ironMg: (json['iron_mg'] as num).toDouble(),
      vitaminCMg: (json['vitamin_c_mg'] as num).toDouble(),
      barcode: json['barcode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'group_name': groupName,
      'energy_kcal': energyKcal,
      'protein_g': proteinG,
      'fat_g': fatG,
      'carbohydrates_g': carbohydratesG,
      'fiber_g': fiberG,
      'sugar_g': sugarG,
      'calcium_mg': calciumMg,
      'iron_mg': ironMg,
      'vitamin_c_mg': vitaminCMg,
      'barcode': barcode,
    };
  }
}