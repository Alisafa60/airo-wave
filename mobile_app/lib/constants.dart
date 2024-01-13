import 'package:flutter/material.dart';

class Constants {
  static const String baseUrl = 'http://172.25.135.58:3000';
}

const Color primaryColor = const Color.fromRGBO(255, 115, 29, 1);

class CustomSearchTextField extends StatelessWidget {
  final String hintText;
  final IconData? customIcon;

  const CustomSearchTextField({
    Key? key,
    required this.hintText,
    this.customIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: TextField(
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color.fromRGBO(74, 74, 74, 0.4),
          ),
          prefixIcon: customIcon != null
              ? Icon(
                  customIcon,
                  color: Color.fromRGBO(74, 74, 74, 0.7),
                )
              : null,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115, 29, 0.6)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.2)),
          ),
        ),
      ),
    );
  }
}