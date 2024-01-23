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