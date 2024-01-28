import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/api_service.dart';


class OpenAiService {
  final ApiService apiService;

  OpenAiService(this.apiService);

  Future<Map<String, dynamic>> sendToOpenAI(String userMessage) async {
    try {
      final String? token = await _getToken();

      if (token != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        final Map<String, dynamic> requestBody = {
          'userMessage': userMessage,
        };

        final http.Response response = await apiService.post(
          '/api/medcat/message', 
          headers,
          requestBody,
        );

        if (response.statusCode == 201) {

          final Map<String, dynamic> responseData = json.decode(response.body);
          return responseData;
        } else {
          throw Exception('Failed to send request to OpenAI. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } else {
        throw Exception('Token is null. Unable to make the API request.');
      }
    } catch (error) {
      throw Exception('Error during OpenAI API call: $error');
    }
  }
    static Future<String?> _getToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: 'jwtToken');
  }

  Future<Map<String, dynamic>> getChatbotResponse() async {
     String? token = await _getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token'};

      try {
        final http.Response response = await apiService.get(
          '/api/medcat/message',
          headers,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return data;
        } else {
          throw Exception('Failed to post chatbot response. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } catch (error) {
        throw Exception('Error during health data API call: $error');
      }
    } else {
      throw Exception('Token is null. Unable to make the API request.');
    }
  }
}