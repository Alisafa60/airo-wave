import 'package:flutter/material.dart';

class Constants {
  static const String baseUrl = 'http://172.25.135.58:3000';
}

const Color primaryColor =  Color.fromRGBO(255, 115, 29, 1);
const Color secondaryColor = Color.fromRGBO(95, 157, 247, 1);
const Color myGray = Color.fromRGBO(74, 74, 74, 1);

class BorderedInputField extends StatelessWidget {
  final String hintText;
  final IconData? customIcon;
  final String errorText;
  final TextEditingController? controller;

  const BorderedInputField({
    Key? key,
    required this.hintText,
    this.customIcon,
    this.errorText = "",
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      child: TextField(
        controller: controller, // Set the provided controller
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
              color: errorText.isNotEmpty ? Colors.red : Color.fromRGBO(74, 74, 74, 0.2),
            ),
          ),
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const SaveButton({Key? key, required this.buttonText, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class UnderlineField extends StatelessWidget {
  final String hintText;

  const UnderlineField({Key? key, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      child: TextField(
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: myGray.withOpacity(0.6),
          ),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: primaryColor.withOpacity(0.6)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: myGray.withOpacity(0.2),
          ),
        ),
      ),
      ),
    );
  }
}
