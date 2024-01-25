import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/api_service.dart';

class SaveAllergenService {
  final ApiService apiService;
  SaveAllergenService(this.apiService);

  static Future<String?> _getToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: 'jwtToken');
  }

   Future<void> saveAllergenData(List<Map<String, dynamic>> allergenData) async {
    String? token = await _getToken();

    if (token != null) {
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      try {
        for (final allergen in allergenData) {
          final String name = allergen['displayName'];
          final String color = allergen['color'];

          final Map<String, dynamic> requestBody = {
            'name': name,
            'color': color,
          };

          final http.Response response = await apiService.post(
            '/api/user/health/allergen',
            headers,
            requestBody,
          );

          if (response.statusCode == 201) {
            print('Allergen added successfully');
          } else {
            throw Exception('Failed to post allergen. Status code: ${response.statusCode}, Body: ${response.body}');
          }
        }
      } catch (error) {
        throw Exception('Error during API post: $error');
      }
    } else {
      throw Exception('Token is null. Unable to make the API request.');
    }
  }
}