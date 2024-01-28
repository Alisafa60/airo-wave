import 'package:flutter/material.dart';
import 'package:mobile_app/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isVisited = false;
  bool isLoading = false; 

  Future<bool> isFirstLogin() async {
    final String email = emailController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLogin = prefs.getBool('firstLogin_$email');

    if (isFirstLogin == null || isFirstLogin) {
      await prefs.setBool('firstLogin_$email', false);
      return true;
    }

    return isFirstLogin;
  }

  Future<void> markHealthScreenVisited() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('healthScreenVisited', true);
  }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true; 
    });

    final String email = emailController.text;
    final String password = passwordController.text;
    final Map<String, String> requestBody = {'email': email, 'password': password};
    final BuildContext currentContext = context;

    try {
      final http.Response response = await widget.apiService.post1('/auth/login', requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String? token = data['token'];

        if (token != null && token.isNotEmpty) {
          await saveToken(token);
          if (await isFirstLogin()) {
            Navigator.pushReplacementNamed(currentContext, '/health');
          } else {
            Navigator.pushReplacementNamed(currentContext, '/home');
          }
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
    } finally {
      setState(() {
        isLoading = false;
      });
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
      resizeToAvoidBottomInset: false,
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
              onPressed: isLoading ? null : loginUser,
            ),
            if (isLoading) 
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}