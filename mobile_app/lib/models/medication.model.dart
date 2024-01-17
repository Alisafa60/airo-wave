class MedicationData {
  final String medication;
  final String dosage;
  final String frequency;
  final String startDate;
  final String healthCondition;

  MedicationData({
    required this.medication,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    required this.healthCondition,
  });

  Map<String, dynamic> toJson() {
    return {
      'medication': medication,
      'dosage': dosage,
      'frequency': frequency,
      'startDate': startDate,
      'healthCondition': healthCondition,
    };
  }
}
