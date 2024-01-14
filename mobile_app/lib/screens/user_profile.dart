import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile_app/constants.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/api_survice.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class UserProfileScreen extends StatefulWidget {
  final ApiService apiService;

  const UserProfileScreen({super.key, required this.apiService});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey _containerKey = GlobalKey();
  bool _isMetric = true; 
  String? _imagePath;
  String? _selectedGender;
  String? uploadedImagePath;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController adressController = TextEditingController();
  
  Future<String?> getToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: 'jwtToken');
  }

  Future<void> updateProfile() async {
  String? token = await getToken();
  final String firstName = firstNameController.text;
  final String lastName = lastNameController.text;
  final String gender = _selectedGender??'';
  final String phone = phoneNumberController.text;
  final String address = adressController.text;
  final String unitPreference = _isMetric ? 'Metric' : 'Imperial';
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

  print(decodedToken);

  if (token != null) {
    final Map<String, String> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final Map<String, dynamic> requestBody = {
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'adress': address,
    'gender': gender,
    'unit': unitPreference,
  };

    try {
      final http.Response response = await widget.apiService.put(
        '/api/user/profile',
        headers,
        requestBody,
      );

      if (response.statusCode == 200) {
        print('Profile update successful');
        print(requestBody);
        
      } else {
        print('Profile update failed. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
      print('Error during profile update: $error');
    }
  }
}

  Future<String?> _uploadImage(String imagePath) async {
    String? token = await getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token'};
      final List<int> bytes = await File(imagePath).readAsBytes();
      final http.MultipartFile file = http.MultipartFile.fromBytes(
        'profilePicture',
        bytes,
        filename: 'filename.jpg',
        contentType: MediaType.parse('image/jpeg'),
      );

      final Map<String, dynamic> body = {'profilePicture': file};

      try {
        final http.Response response = await widget.apiService.postMultipart(
          '/api/user/profile-picture',
          headers,
          body,
        );

        print('Image upload response: ${response.statusCode}, Body: ${response.body}');

        if (response.statusCode == 201) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final String uploadedImagePath = responseData['imageUrl'];
          return uploadedImagePath;
        } else {
            print('Image upload failed. Status code: ${response.statusCode}, Body: ${response.body}');
            return null; 
          }
        } catch (error) {
          print('Error during image upload: $error');
          return null; 
        }
      }
      return null; 
    }

  Future<void> _handleDelete() async {
    String? token = await getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token'};

      try {
        final http.Response response = await widget.apiService.delete(
          '/api/user/profile-picture',
          headers,
        );

        if (response.statusCode == 204) {
          setState(() {
            _imagePath = null;
          });
        } else {
          print('Profile picture deletion failed. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } catch (error) {
        print('Error during profile picture deletion: $error');
      }
    }
  }

  Future<String?> getImagePath() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image?.path;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  Future<void> _handleUpload() async {
    String? imagePath = await getImagePath();
    if (imagePath != null) {
      String? uploadedImagePath = await _uploadImage(imagePath);

      if (uploadedImagePath != null) {
        setState(() {
          _imagePath = uploadedImagePath;
          print('Image Path: $_imagePath');
        });
      } else {
        print('Image upload failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
            "Profile",
            selectionColor: Color.fromRGBO(74, 74, 74, 1),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
          ),),
          centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(74, 74, 74, 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: IconButton(
              icon: const Icon(Icons.clear),
              color: const Color.fromRGBO(74, 74, 74, 1),
              onPressed: () {},
              iconSize: 30,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                key: _containerKey,
                color: const Color.fromRGBO(255, 252, 252, 1),
                child: GestureDetector(
                  onTap: () {
                    showPopupMenu(context);
                  },
                  child: ClipOval(
                    child: Container(
                      
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: _imagePath != null
                            ? DecorationImage(
                                image: NetworkImage('/172.25.135.58:3000/$_imagePath'),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image: AssetImage('lib/assets/images/profile-picture.png'),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50,),
            UnderlineInputField(controller: firstNameController, hintText: ' First name'),
            const SizedBox(height: 20,),
            UnderlineInputField(controller: lastNameController, hintText: ' Last name'),
            const SizedBox(height: 20,),
            UnderlineInputField(controller: phoneNumberController, hintText: ' Phone number'),
            const SizedBox(height: 20,),
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select gender',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 0.4),
                  ),
                  border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115 , 29, 0.6)), 
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.4)), 
                  ),
                ),
                value: _selectedGender,
                items: ['Male', 'Female', 'Other'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender,),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20,),
            UnderlineInputField(controller: adressController, hintText: ' Adress'),
            const SizedBox(height: 20,),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  ' Preferred Units',
                  style: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 1),
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _isMetric ? 'Metric' : 'Imperial',
                      style: const TextStyle(
                        color: Color.fromRGBO(74, 74, 74, 0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      value: _isMetric,
                      onChanged: (value) {
                        setState(() {
                          _isMetric = value;
                        });
                      },
                      activeColor: Color.fromRGBO(255, 115, 29, 0.6),
                      inactiveThumbColor: Color.fromRGBO(95, 157, 247, 0.8),
                      activeTrackColor: Color.fromRGBO(255, 115, 29, 0.2),
                      inactiveTrackColor: Color.fromRGBO(95, 157, 247, 0.4),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30,),
            SaveButton(
                buttonText: 'Save',
                onPressed: updateProfile,
            )
          ],
          
        ),
      ),
    );
  }
  
  void showPopupMenu(BuildContext context) {
    PopupMenu menu = PopupMenu(
      context: context,
      config: const MenuConfig(
        backgroundColor: Color.fromRGBO(220, 218, 218, 0.2),
      ),
      items: [
        MenuItem(
          title: 'Delete',
          textStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          image: const Icon(Icons.delete, color: Colors.red),
        ),
        MenuItem(
          title: 'Upload',
          textStyle: const TextStyle(color: Color.fromRGBO(95, 157, 247, 1), fontWeight: FontWeight.w600),
          image: const Icon(Icons.upload, color: Color.fromRGBO(95, 157, 247, 1)),
        ),
      ],
      onClickMenu: (MenuItemProvider item) async {
        if (item.menuTitle == 'Upload') {
          await _handleUpload(); 
        } else if (item.menuTitle == 'Delete') {
          await _handleDelete();
        }
        print('Menu item clicked: ${item.menuTitle}');
      },
    );
    menu.show(widgetKey: _containerKey);

  }
}
