import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';
import 'package:popup_menu/popup_menu.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isMetric = true;
  String? _selectedGender;


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
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: myGray,
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
            const SizedBox(height: 10),
            const BorderedInputField(hintText: 'Email'),
            const SizedBox(height: 20),
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: myGray,
              ),
            ),
            const SizedBox(height: 10),
            const BorderedInputField(hintText: 'Password'),
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
              'Profile Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: myGray,
              ),
            ),
            SizedBox(height: 15,),
            const Row(
                children:[ 
                  Expanded(child: BorderedInputField(hintText: 'First Name')),
                  SizedBox(width: 10),
                  Expanded(child: BorderedInputField(hintText: 'Last Name')),
                ]
            ),
            SizedBox(height: 20,),
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
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
                value: null,
                items: ['Male', 'Female', 'Other'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                   
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Preferred Units',
                  style: TextStyle(
                    color: myGray,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                     Text(
                      'Metric',
                      style: TextStyle(
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
            SizedBox(height: 20),
            SaveButton(buttonText: 'Sign Up')
          ],
        ),
      ),
    );
  }
}
