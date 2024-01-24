import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnviromentalService {
  final ApiService apiService;
  EnviromentalService(this.apiService);

  Future<Map<String, dynamic>> getEnviromental() async {
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

  Future<void> fetchAirQualityDataAndPost(double latitude, double longitude) async {
    try {
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
      final apiUrl = "https://airquality.googleapis.com/v1/currentConditions:lookup?key=$apiKey";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'location': {'latitude': latitude, 'longitude': longitude},
          "extraComputations": [
            "HEALTH_RECOMMENDATIONS",
            "DOMINANT_POLLUTANT_CONCENTRATION",
            "POLLUTANT_CONCENTRATION",
            "LOCAL_AQI",
            "POLLUTANT_ADDITIONAL_INFO"
          ],
          "languageCode": "en"
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final aqi = responseData['indexes'][0]['aqi'];
        final aqiCategory = responseData['indexes'][0]['category'];
        final coLevel = responseData['pollutants'].firstWhere((pollutant) => pollutant['code'] == 'co')['concentration']['value'];
        final so2Level = responseData['pollutants'].firstWhere((pollutant) => pollutant['code'] == 'so2')['concentration']['value'];
        final o3Level = responseData['pollutants'].firstWhere((pollutant) => pollutant['code'] == 'so2')['concentration']['value'];
        final pm10 = responseData['pollutants'].firstWhere((pollutant) => pollutant['code'] == 'so2')['concentration']['value'];
        final no2Level = responseData['pollutants'].firstWhere((pollutant) => pollutant['code'] == 'no2')['concentration']['value'];
        final pm25 = responseData['pollutants'].firstWhere((pollutant) => pollutant['code'] == 'pm25')['concentration']['value'];
        final dominantPollutant = responseData['indexes'][0]['dominantPollutant'];

        await postEnvironmentalData(
          latitude: latitude,
          longitude: longitude,
          aqi: aqi,
          aqiCategory: aqiCategory,
          o3Level: o3Level,
          pm10: pm10,
          so2Level: so2Level,
          pm25: pm25,
          coLevel: coLevel,
          no2Level: no2Level,
          dominantPollutant: dominantPollutant,
        );

        
      } else {
        print('Failed to fetch air quality data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching or posting data: $error');
    }
  }

  Future<Map<String, dynamic>> postEnvironmentalData({
    required double latitude,
    required double longitude,
    required int aqi,
    required String aqiCategory,
    required double o3Level,
    required double pm10,
    required double so2Level,
    required double pm25,
    required double coLevel,
    required double no2Level,
    required String dominantPollutant,
  }) async {
    String? token = await _getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
      
      try {
        final Map<String, dynamic> requestBody = {
          'location': {
            'latitude': latitude,
            'longitude': longitude,
          },
          'aqi': aqi,
          'aqiCategory': aqiCategory,
          'o3Level': o3Level,
          'pm10': pm10,
          'so2Level': so2Level,
          'pm25': pm25,
          'coLevel': coLevel,
          'no2Level': no2Level,
          'dominantPollutant': dominantPollutant,
        };

        final http.Response response = await apiService.post(
          '/api/user/latest-environmental-data',
          headers,
          requestBody,
        );
        print(requestBody);
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