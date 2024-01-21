import 'package:flutter/material.dart';

void handleBarTapped(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushReplacementNamed(context, '/home');
      break;
    case 1:
      Navigator.pushReplacementNamed(context, '/medcat');
      break;
    case 2:
      Navigator.pushReplacementNamed(context, '/maps');
      break;
    case 3:
      Navigator.pushReplacementNamed(context, '/record');
      break;
    case 4:
      Navigator.pushReplacementNamed(context, '/home/profile');
      break;
  }
}
