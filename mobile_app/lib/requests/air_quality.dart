import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> fetchAirQualityData(double latitude, double longitude) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];;
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
    final url = 'http://172.25.135.58:3000/savefile';

    http.post(Uri.parse(url), body: response.body);
    print("responed sucess");
    print(response.body);
    } else {
      print('Failed to fetch air quality data. Status code: ${response.statusCode}');
    }
  }

  