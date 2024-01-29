import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/api_service.dart';

class HealthService {
  final ApiService apiService;
  HealthService(this.apiService);

  Future<Map<String, dynamic>> getUserHealthData() async {
     String? token = await _getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token'};

      try {
        final http.Response response = await apiService.get(
          '/api/user/health',
          headers,
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
    } else {
      throw Exception('Token is null. Unable to make the API request.');
    }
  }

  static Future<String?> _getToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: 'jwtToken');
  }

  Future<Map<int, dynamic>> updateWeight({
    required weight,
  }) async {
    String? token = await _getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
      
      try {
        final Map<int, dynamic> requestBody = {
          weight: int.parse(weight),
        };

        final http.Response response = await apiService.post(
          '/api/user/health/edit',
          headers,
          requestBody.cast<String, dynamic>(),
        );
        print(requestBody);
        if (response.statusCode == 201) {
          final Map<int, dynamic> updateWeight = json.decode(response.body);
          return updateWeight;
        } else {
          throw Exception('Failed to update medication. Status code: ${response.statusCode}, Body: ${response.body}, response: ${response}');
        }
      } catch (error) {
        throw Exception('Error during medication update API call: $error');
      }
    } else {
      throw Exception('Token is null. Unable to make the API request.');
    }
  }
}