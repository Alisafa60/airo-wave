import 'package:flutter/material.dart';
import 'package:mobile_app/api_service.dart';
import 'package:mobile_app/constants.dart';
import 'package:http/http.dart' as http;

import 'package:mobile_app/widgets/dropdown_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  final ApiService apiService;
  const SignupScreen({super.key, required this.apiService});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String errorText = '';
  bool _isMetric = true;
  String? selectedGender;
  bool isHealthProfessional = false;
  bool isLoading = false;

  Future<void> signupUser() async {
    setState(() {
      isLoading = true; 
    });

    final String email = emailController.text;
    final String password = passwordController.text;
    final String firstName = firstNameController.text;
    final String lastName = lastNameController.text;
    final String gender = selectedGender ?? '';
    final String unitPreference = _isMetric ? 'Metric' : 'Imperial';
    final String userType = isHealthProfessional ? 'healthProfessional' : 'user';

    final Map<String, String> requestBody = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'unit': unitPreference,
      'type': userType,
    };

    try {
      final http.Response response = await widget.apiService.post1('/auth/register', requestBody);

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/login');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('healthScreenVisited');
        await prefs.remove('firstLogin');
      } else {
        setState(() {
          errorText = 'Invalid email/password';
        });
        print('Signup failed. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
      setState(() {
        errorText = 'Error during signup: $error';
      });
      print('Error during signup: $error');
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(74, 74, 74, 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child:  Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create an Account",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: myGray,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              ' Email',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: myGray,
              ),
            ),
            const SizedBox(height: 10),
            BorderedInputField(
              hintText: 'Email',
              controller: emailController,
            ),
            const SizedBox(height: 20),
            const Text(
              ' Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: myGray,
              ),
            ),
            const SizedBox(height: 10),
            BorderedInputField(
              hintText: 'Password',
              controller: passwordController,
            ),
            const SizedBox(height: 5),
            Text(
              'Password must contain at least 8 characters',
              style: TextStyle(
                color: myGray.withOpacity(0.6),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              ' Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: myGray,
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: BorderedInputField(
                    hintText: 'First Name',
                    controller: firstNameController,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BorderedInputField(
                    hintText: 'Last Name',
                    controller: lastNameController,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            GenderDropdownForm(
              currentValue: selectedGender,
              onChanged: (String? value) {
                print('selected gender: $value');
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            const SizedBox(height: 20),
            PreferredUnitsSwitch(
              isMetric: _isMetric,
              onChanged: (value) {
                setState(() {
                  _isMetric = value;
                });
              },
            ),
            Row(
              children: [
                Text(
                  ' Are you a health professional?',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 8.0),
                Checkbox(
                  value: isHealthProfessional,
                  onChanged: (value) {
                    setState(() {
                      isHealthProfessional = value!;
                    });
                  },
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    ' Login?',
                    style: TextStyle(
                      fontSize: 16,
                      color: myGray.withOpacity(0.6),
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SaveButton(
              buttonText: 'Sign Up',
              onPressed: isLoading ? null : signupUser,
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
