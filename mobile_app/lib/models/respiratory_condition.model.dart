class RespiratoryConditionData {
  final String condition;
  final String diagnosis;
  final String symptomsFrequency;
  final String triggers;

  RespiratoryConditionData({
    required this.condition,
    required this.diagnosis,
    required this.symptomsFrequency,
    required this.triggers,
  });

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'diagnosis': diagnosis,
      'symptomsFrequency': symptomsFrequency,
      'triggers': triggers,
    };
  }
}
