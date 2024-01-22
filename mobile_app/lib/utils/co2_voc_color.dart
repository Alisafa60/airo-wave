import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';

Color getStatusColor(int value, String type) {
  if (type == 'co2') {
    if (value < 600) {
      return secondaryColor;
    } else if (value < 1400) {
      return primaryColor;
    } else if (value < 2000) {
      return Colors.red;
    } else {
      return Colors.red; 
    }
  } else if (type == 'voc') {
    if (value < 220) {
      return secondaryColor;
    } else if (value < 660) {
      return primaryColor;
    } else if (value < 1400) {
      return Colors.red;
    } else if (value < 2000) {
      return Colors.red;
    } else {
      return Colors.red;
    }
  } else {
    return Colors.black;
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
