import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';

Color getStatusColor(int value, String type) {
  if (type == 'co2') {
    if (value < 600) {
      return secondaryColor;
    } else if (value < 1400) {
      return primaryColor;
    } else {
      return Colors.red; 
    }
  } else if (type == 'voc') {
    if (value < 220) {
      return secondaryColor;
    } else if (value < 660) {
      return primaryColor;
    }else {
      return Colors.red;
    }
  } else if (type == 'aqi') {
    if (value < 50) {
      return secondaryColor;
    } else if (value < 100) {
      return Color.fromARGB(255, 255, 161, 53);
    } else if (value < 150) {
      return primaryColor;
    } else {
      return Colors.red;
    }
  } else {
    return Colors.black;
  }
}

Color getColorEnv(double value, String type){
  
  if (type == 'co') {
    if (value < 30) {
      return secondaryColor;
    } else if (value < 70) {
      return Color.fromARGB(255, 255, 161, 53);
    } else if (value < 150) {
      return primaryColor;
    } else {
      return Colors.red;
    }
  } else if (type == 'so2') {
    if (value < 0.1) {
      return secondaryColor;
    } else if (value < 0.2) {
      return Color.fromARGB(255, 255, 161, 53);
    } else if (value < 1) {
      return primaryColor;
    } else {
      return Colors.red;
    }
  } else if (type == 'pm10') {
    if (value < 54) {
      return secondaryColor;
    } else if (value < 150) {
      return Color.fromARGB(255, 255, 161, 53);
    } else if (value < 250) {
      return primaryColor;
    } else {
      return Colors.red;
    }
  }else if (type=='no2'){
    if (value < 54) {
      return secondaryColor;
    } else if (value < 100) {
      return Color.fromARGB(255, 255, 161, 53);
    } else if (value < 360) {
      return primaryColor;
    } else {
      return Colors.red;
    }
  }else{
    return Colors.black;
  }
}


Color getColorForCO(double coLevel) {
  if (coLevel < 30) {
    return secondaryColor; 
  } else if (coLevel < 70) {
    return Color.fromARGB(255, 255, 161, 53); 
  } else if (coLevel < 150) {
    return primaryColor; 
  } else {
    return Colors.red; 
  }
}

String getStatusText(int value, String type) {
  if (type == 'co2') {
    if (value < 600) {
      return 'Good';
    } else if (value < 1400) {
      return 'Moderate';
    } else if (value < 2000) {
      return 'High';
    } else {
      return 'Very High';
    }
  } else if (type == 'voc') {
    if (value < 220) {
      return 'Good';
    } else if (value < 660) {
      return 'Moderate';
    } else if (value < 1400) {
      return 'High';
    } else if (value < 2000) {
      return 'Very High';
    } else {
      return 'Very High';
    }
  } else {
    return 'Unknown'; 
  }
}
