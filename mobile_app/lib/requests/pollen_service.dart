import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> postPollenData(double latitude, double longitude) async {
    try {
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']; 
      final apiUrl = "https://pollen.googleapis.com/v1/forecast:lookup?key=$apiKey&location.longitude=$longitude&location.latitude=$latitude&days=1";

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> pollenData = json.decode(response.body);
        print(pollenData);
        final postUrl = 'http://172.25.135.58:3000/savefile';
        final postResponse = await http.post(
          Uri.parse(postUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(pollenData),
        );

        if (postResponse.statusCode == 200) {
          print('Data posted successfully');
        } else {
          print('Error posting data. Status code: ${postResponse.statusCode}');
        }
      } else {
        print('Error fetching pollen data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during data request and posting: $e');
    }
  }


class PollenService {
  final ApiService apiService;
  PollenService(this.apiService);

  Future<Map<String, dynamic>> getPollen() async {
     String? token = await _getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token'};

      try {
        final http.Response response = await apiService.get(
          '/api/user/latest-environmental-data',
          headers,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return data;
        } else {
          throw Exception('Failed to load environmental health data. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } catch (error) {
        throw Exception('Error during environmental data API call: $error');
      }
    } else {
      throw Exception('Token is null. Unable to make the API request.');
    }
  }

  static Future<String?> _getToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: 'jwtToken');
  }

  Future<void> fetchAndPostPollen(double latitude, double longitude) async {
    try {
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']; 
      final apiUrl = "https://pollen.googleapis.com/v1/forecast:lookup?key=$apiKey&location.longitude=$longitude&location.latitude=$latitude&days=1";

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final location = {'latitude': latitude, 'longitude': longitude};

        await postPollen(jsonData: responseData, location: location);
        
      } else {
        print('Failed to fetch air quality data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching or posting data: $error');
    }
  }

  Future<Map<String, dynamic>> postPollen({
    required Map<String, dynamic> jsonData,
    required Map<String, dynamic> location,
  }) async {
    String? token = await _getToken();

    if (token != null) {
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      try {
        final http.Response response = await apiService.post(
          '/api/user/environmental-data',
          headers,
          {
            'allergen_data': jsonData,
            'location': location,
          },
        );

        if (response.statusCode == 201) {
          final Map<String, dynamic> environmentalData = json.decode(response.body) as Map<String, dynamic>;
          return environmentalData;
        } else {
          throw Exception('Failed to post environmental data. Status code: ${response.statusCode}, Body: ${response.body}, response: ${response}');
        }
      } catch (error) {
        throw Exception('Error during environmental data update API call: $error');
      }
    } else {
      throw Exception('Token is null. Unable to make the API request.');
    }
  }

}