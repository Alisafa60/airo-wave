import 'dart:ffi';

class EnvironmentalData {
  final int aqi;
  final String aqiCategory;
  final Float latitude;
  final Float longitude;
  final Float so2Level;
  final Float o3Level;
  final Float pm10;
  final Float pm25;
  final Float coLevel;
  final Float no2Level;
  final String dominantPollutant;

  EnvironmentalData({
    required this.aqi,
    required this.aqiCategory,
    required this.so2Level,
    required this.latitude,
    required this.longitude,
    required this.o3Level,
    required this.pm10,
    required this.pm25,
    required this.coLevel,
    required this.no2Level,
    required this.dominantPollutant
  });

  Map<String, dynamic> toJson() {
    return {
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'aqi': aqi,
      'aqiCategory': aqiCategory,
      'o3Level': o3Level,
      'so2Level': so2Level,
      'pm10': pm10,
      'pm25': pm25,
      'coLevel': coLevel,
      'no2Level': no2Level,
      'dominantPollutant': dominantPollutant,
    };
  }
}
