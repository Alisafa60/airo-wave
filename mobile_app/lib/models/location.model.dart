import 'dart:ffi';

class UserLocation {
  final Float latitude;
  final Float longitude;

  UserLocation({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
    };
  }
}
