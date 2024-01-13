import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/constants.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<http.Response> post(String path, Map<String, String> body) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return response;
    } catch (error) {
      throw Exception('Error during API call: $error');
    }
  }
}
