import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> fetchPollenData(double latitude, double longitude) async {
  try {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']; 
    final apiUrl = "https://pollen.googleapis.com/v1/forecast:lookup?key=$apiKey&location.longitude=$longitude&location.latitude=$latitude&days=1";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> pollenData = json.decode(response.body);
      print('Pollen Data: $pollenData');
    } else {
      print('Error fetching pollen data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception during pollen data request: $e');
  }
}