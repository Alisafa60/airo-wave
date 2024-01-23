class Pollen {
  final int allergen1;
  final int allergen2;
  final int allergen3;
  final int allergen4;
  final int allergen5;

  Pollen({
    required this.allergen1,
    required this.allergen2,
    required this.allergen3,
    required this.allergen4,
    required this.allergen5,
  });

  Map<String, dynamic> toJson() {
    return {
      'allergen1': allergen1,
      'allergen2': allergen2,
      'allergen3': allergen3,
      'allergen4': allergen4,
      'allergen5': allergen5,
    };
  }
}
