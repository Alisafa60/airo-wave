import 'package:flutter/material.dart';
import 'package:mobile_app/api_survice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/constants.dart';

class LoginScreen extends StatefulWidget {
  final ApiService apiService;
  const LoginScreen({super.key, required this.apiService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String loginError = '';
  

  Future<void> loginUser() async {
    final String email = emailController.text;
    final String password = passwordController.text;
    
    final Map<String, String> requestBody = {'email': email, 'password': password};
    print(requestBody);
    try {
      final http.Response response = await widget.apiService.post1('/auth/login', requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Login successful: $data');

        final String? token = data['token'];
        if (token != null && token.isNotEmpty) {
          await saveToken(token);
        } else {
          print('Invalid or empty token received.');
        }
      } else {
        setState(() {
          loginError = 'Invalid email/password';
        });
        print('Login failed. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
      print('Error during login: $error');
    }
  }
  
  Future<void> saveToken(String token) async {
    try {
      final FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.write(key: 'jwtToken', value: token);
      print('Token saved successfully: $token');
    } catch (error) {
      print('Error saving token: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Log In",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(46, 46, 46, 1),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: myGray,
              ),
            ),
            const SizedBox(height: 10,),
            BorderedInputField(hintText: 'Email', controller: emailController,),
            const SizedBox(height: 20),
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: myGray,
              ),
            ),
            const SizedBox(height: 10,),
            BorderedInputField(hintText: 'Password', controller: passwordController,),
            const SizedBox(height: 5,),
            GestureDetector(
              onTap: () {
                
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Color.fromRGBO(74, 74, 74, 0.6),
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 2,),
            Text(loginError, style: TextStyle(color: Colors.red, fontSize: 15),),
            const SizedBox(height: 30),
            SaveButton(
              buttonText: 'Log In',
              onPressed: loginUser,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: Color.fromRGBO(74, 74, 74, 0.6),
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 247, 241),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
              ),
              child: Row(
                children: [
                  // Add the Google logo here
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(
                      'lib/assets/images/google.png',
                      height: 24,
                      width: 24,
                    ),
                  ),
                  const SizedBox(width: 55,),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: Color.fromRGBO(74, 74, 74, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 247, 241),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
              ),
              child: const Row(
                children: [
                  // Add the Google logo here
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.facebook,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 52,),
                  Text(
                    'Continue with Facebook',
                    style: TextStyle(
                      color: Color.fromRGBO(74, 74, 74, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 247, 241),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
              ),
              child: const Row(
                children: [
                  // Add the Google logo here
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.apple,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 60,),
                  Text(
                    'Continue with Apple',
                    style: TextStyle(
                      color: Color.fromRGBO(74, 74, 74, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
