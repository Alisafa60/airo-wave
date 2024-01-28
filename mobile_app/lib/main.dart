import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/api_service.dart';

import 'package:mobile_app/screens/health_data.dart';
import 'package:mobile_app/screens/home.dart';
import 'package:mobile_app/screens/login.dart';
import 'package:mobile_app/screens/maps.dart';
import 'package:mobile_app/screens/med_cat.dart';

import 'package:mobile_app/screens/record_activity.dart';

import 'package:mobile_app/screens/signup.dart';
import 'package:mobile_app/screens/user_profile.dart';
import 'package:mobile_app/screens/user_health.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/widgets/activity_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ApiService apiService = ApiService(Constants.baseUrl);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(255, 115, 15, 1)),
        useMaterial3: true,
      ),
      // home: SignupScreen(apiService: apiService,),
      initialRoute: '/',
      routes: {
        '/': (context) => SignupScreen(apiService: apiService),
        '/login': (context) => LoginScreen(apiService: apiService),
        '/home': (context) => HomeScreen(apiService: apiService,),
        '/home/profile/edit': (context) => UserProfileScreen(apiService: apiService),
        '/home/profile': (context) => ShowHealthScreen(apiService: apiService),
        '/health': (context) => UserHealthScreen(apiService: apiService),
        '/medcat': (context) => MedCatScreen(apiService: apiService,),
        '/maps': (context) => MapsScreen(apiService: apiService,),
        '/record':(context) => RecordActivityScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
