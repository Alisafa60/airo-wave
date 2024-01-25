import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';


class BorderedInputField extends StatelessWidget {
  final String hintText;
  final IconData? customIcon;
  final String errorText;
  final TextEditingController? controller;

  const BorderedInputField({
    super.key,
    required this.hintText,
    this.customIcon,
    this.errorText = "",
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      child: TextField(
        controller: controller, 
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        obscureText: hintText.toLowerCase().contains('password'),
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
            borderSide: BorderSide(
              width: 2,
              color: errorText.isNotEmpty ? Colors.red : primaryColor.withOpacity(0.6),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              width: 2,
              color: errorText.isNotEmpty ? Colors.red : myGray.withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }
}

class UnderlineInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const UnderlineInputField({super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: myGray.withOpacity(0.4),
          ),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: primaryColor.withOpacity(0.6)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: myGray.withOpacity(0.4)),
          ),
        ),
      ),
    );
  }
}