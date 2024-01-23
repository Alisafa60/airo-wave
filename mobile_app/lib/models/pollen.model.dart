class Pollen {
  final int allergen1;
  final int allergen2;
  final int allergen3;
  final int allergen4;

  Pollen({
    required this.allergen1,
    required this.allergen2,
    required this.allergen3,
    required this.allergen4,
  });

  Map<String, dynamic> toJson() {
    return {
      'allergen1': allergen1,
      'allergen2': allergen2,
      'symptomsFrequency': allergen3,
      'triggers': allergen4,
    };
  }
}
