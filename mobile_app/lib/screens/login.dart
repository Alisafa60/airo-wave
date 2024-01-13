import 'package:flutter/material.dart';
import 'package:mobile_app/api_survice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  final ApiService apiService;
  LoginScreen({super.key, required this.apiService});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorText = '';
  
  Future<void> loginUser(String email, String password) async {
    final Map<String, String> requestBody = {'email': email, 'password': password};

    try {
      final http.Response response = await widget.apiService.post('/auth/login', requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Login successful: $data');
      } else {
        setState(() {
          errorText = 'Invalid email/password';
        });
        print('Login failed. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
       setState(() {
        errorText = 'Error during login: $error';
      });
      print('Error during login: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
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
                color: Color.fromRGBO(74, 74, 74, 1),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: errorText.isNotEmpty ? Colors.red : const Color.fromRGBO(74, 74, 74, 0.5)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: emailController,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 0.4),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(74, 74, 74, 1),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: errorText.isNotEmpty ? Colors.red : const Color.fromRGBO(74, 74, 74, 0.5)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: passwordController,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.bottom,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 0.4),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 5,),
            GestureDetector(
              onTap: () async {
                
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
            Text(errorText, style: TextStyle(color: Colors.red, fontSize: 15),),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                // Get the email and password from the TextFields
                String email = emailController.text;
                String password = passwordController.text;

                // Call the loginUser function
                await loginUser(email, password);
              },
              child: Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 115, 19, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
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
