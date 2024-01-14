import 'package:flutter/material.dart';
import 'package:mobile_app/api_survice.dart';
import 'package:mobile_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SignupScreen extends StatefulWidget {
  final ApiService apiService;
  SignupScreen({super.key, required this.apiService});
  

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String errorText = '';
  bool _isMetric = true;
  String? _selectedGender;
  bool isHealthProfessional = false;

   Future<void> signupUser() async {
    final String email = emailController.text;
    final String password = passwordController.text;
    final String firstName = firstNameController.text;
    final String lastName = lastNameController.text;
    final String gender = _selectedGender??'';
    final String unitPreference = _isMetric ? 'Metric' : 'Imperial';
    final String userType = isHealthProfessional ? 'healthProfessional' : 'user';
    print(userType);
    final Map<String, String> requestBody = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'unit': unitPreference,
      'type': userType,
    };
    print(requestBody);

    try{
      final http.Response response = await widget.apiService.post('/auth/register', requestBody);
      if (response.statusCode == 200){
        final Map<String, dynamic>data = jsonDecode(response.body);
        print('Login successful: $data');
      }else{
        setState(() {
          errorText = 'Invalid email/password';
        });
        print('Login failed. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch(error){
      setState(() {
        errorText = 'Error during login: $error';
      });
      print('Error during login: $error');
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
      body: Padding(
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
            SizedBox(height: 15,),
            Row(
                children:[ 
                  Expanded(child: BorderedInputField(hintText: 'First Name', controller: firstNameController,)),
                  const SizedBox(width: 10),
                  Expanded(child: BorderedInputField(hintText: 'Last Name', controller: lastNameController,)),
                ]
            ),
            SizedBox(height: 20,),
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState){
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Select gender',
                      hintStyle: TextStyle(
                        color: myGray.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: primaryColor.withOpacity(0.6)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: myGray.withOpacity(0.4)),
                      ),
                    ),
                    value: _selectedGender,
                    items: ['Male', 'Female', 'Other'].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      print('selected gender: $value');
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  );
                }
              )
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  ' Preferred Units',
                  style: TextStyle(
                    color: myGray,
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
                      activeColor: primaryColor.withOpacity(0.6),
                      inactiveThumbColor: secondaryColor.withOpacity(0.8),
                      activeTrackColor: primaryColor.withOpacity(0.2),
                      inactiveTrackColor: secondaryColor.withOpacity(0.4),
                    ),
                  ],
                ),
              ],
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
              ],
            ),
            const SizedBox(height: 20),
            SaveButton(
              buttonText: 'Sign Up',
              onPressed: signupUser,
            )
          ],
        ),
      ),
    );
  }
}
