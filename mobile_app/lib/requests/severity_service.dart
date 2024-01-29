import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/api_service.dart';

class SeverityService {
  final ApiService apiService;
  SeverityService(this.apiService);

  static Future<String?> _getToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: 'jwtToken');
  }

   Future<void> addSeverity(int severity) async {
    String? token = await _getToken();

    if (token != null) {
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      try {
          final Map<String, dynamic> requestBody = {
            'severity': severity,
          };

          final http.Response response = await apiService.post(
            '/api/user/daily-health',
            headers,
            requestBody,
          );

          if (response.statusCode == 201) {
            print('Severity added');
          } else {
            throw Exception('Failed to add severity. Status code: ${response.statusCode}, Body: ${response.body}');
          }
        
      } catch (error) {
        throw Exception('Error during API post: $error');
      }
    } else {
      throw Exception('Token is null. Unable to make the API request.');
    }
  }
  Future<Map<String, dynamic>> getSeverity() async {
     String? token = await _getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token'};

      try {
        final http.Response response = await apiService.get(
          '/api/user/daily-health',
          headers,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return data;
        } else {
          throw Exception('Failed to load. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } catch (error) {
        throw Exception('Error during API call: $error');
      }
    } else {
      throw Exception('Token is null. Unable to make the API request.');
    }
  }

}