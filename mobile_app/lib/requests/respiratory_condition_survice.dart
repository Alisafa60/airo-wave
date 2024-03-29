import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/api_service.dart';

class RespiratoryConditionSurvice {
  final ApiService apiService;
  RespiratoryConditionSurvice(this.apiService);
  Future<Map<String, dynamic>> getRespiratoryCondition() async {
     String? token = await _getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token'};

      try {
        final http.Response response = await apiService.get(
          '/api/user/health/respiratoryConditions',
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

  Future<Map<String, dynamic>> updateRespiratoryCondition({
    required String condition,
    String? diagnosis,
    String? symptomsFrequency,
    String? triggers,
  }) async {
    String? token = await _getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
      
      try {
        final Map<String, dynamic> requestBody = {
          'condition': condition,
          'diagnosis': diagnosis,
          'symptomsFrequency': symptomsFrequency,
          'triggers': triggers,
        };

        final http.Response response = await apiService.post(
          '/api/user/health/edit-respiratory-condition',
          headers,
          requestBody,
        );
        print(requestBody);
        if (response.statusCode == 200) {
          final Map<String, dynamic> updatedRespiratoryCondition = json.decode(response.body) as Map<String, dynamic>;
          return updatedRespiratoryCondition;
        } else {
          throw Exception('Failed to update respiratory condition. Status code: ${response.statusCode}, Body: ${response.body}, response: ${response}');
        }
      } catch (error) {
        throw Exception('Error during respiratory condition update API call: $error');
      }
    } else {
      throw Exception('Token is null. Unable to make the API request.');
    }
  }
}