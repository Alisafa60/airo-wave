class SensorData {
  final String co2;
  final String voc;

  SensorData({
    required this.co2,
    required this.voc,
  });

  Map<String, dynamic> toJson() {
    return {
      'co2': co2,
      'voc': voc,
    };
  }
}
