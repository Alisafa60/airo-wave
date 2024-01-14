import 'dart:convert';
import 'package:http/http.dart' as http;

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
  
   Future<http.Response> postMultipart(String path, Map<String, String> headers, Map<String, dynamic> body) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    final http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers);

    // Add each part of the body to the request
    for (MapEntry<String, dynamic> entry in body.entries) {
      if (entry.value is String) {
        request.fields[entry.key] = entry.value;
      } else if (entry.value is http.MultipartFile) {
        request.files.add(entry.value);
      }
    }

    try {
      final http.Response response = await http.Response.fromStream(await request.send());
      return response;
    } catch (error) {
      throw Exception('Error during API call: $error');
    }
  }

  Future<http.Response> delete(String path, Map<String, String> headers) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      final http.Response response = await http.delete(
        uri,
        headers: headers,
      );
      return response;
    } catch (error) {
      throw Exception('Error during API call: $error');
    }
  }

  Future<http.Response> put(String path, Map<String, String> headers, Map<String, dynamic> body) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      final http.Response response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      return response;
    } catch (error) {
      throw Exception('Error during API call: $error');
    }
  }

}

