import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/api_service.dart';

class SensorService {
  final ApiService apiService;
  SensorService(this.apiService);
  Future<Map<String, dynamic>> getSensorData() async {

      try {
        final http.Response response = await apiService.getSensor(
          '/api/latest-sensor-data',
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return data;
        } else {
          throw Exception('Failed to load user health data. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } catch (error) {
        throw Exception('Error during health data API call: $error');
      }
    } 
}
