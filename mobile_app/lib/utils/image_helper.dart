import 'package:shared_preferences/shared_preferences.dart';

class ImageHelper {
  static Future<String?> loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString('profileImagePath');
    
    return savedImagePath;
  }
}
