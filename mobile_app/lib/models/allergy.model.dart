class AllergyData {
  final String allergen;
  final String severity;
  final String duration;
  final String triggers;

  AllergyData({
    required this.allergen,
    required this.severity,
    required this.duration,
    required this.triggers,
  });

  Map<String, dynamic> toJson() {
    return {
      'allergen': allergen,
      'severity': severity,
      'duration': duration,
      'triggers': triggers,
    };
  }
}
