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
              color: errorText.isNotEmpty ? Colors.red : myGray.withOpacity(0.2),
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

  const SaveButton({super.key, required this.buttonText, required this.onPressed});

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

class GenderDropdownFormField extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onChanged;

  const GenderDropdownFormField({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: 'Select gender',
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
            value: selectedGender,
            items: ['Male', 'Female', 'Other'].map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}

class PreferredUnitsSwitch extends StatelessWidget {
  final bool isMetric;
  final ValueChanged<bool> onChanged;

  const PreferredUnitsSwitch({
    super.key,
    required this.isMetric,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
              isMetric ? 'Metric' : 'Imperial',
              style: const TextStyle(
                color: Color.fromRGBO(74, 74, 74, 0.8),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Switch(
              value: isMetric,
              onChanged: onChanged,
              activeColor: primaryColor.withOpacity(0.6),
              inactiveThumbColor: secondaryColor.withOpacity(0.8),
              activeTrackColor: primaryColor.withOpacity(0.2),
              inactiveTrackColor: secondaryColor.withOpacity(0.4),
            ),
          ],
        ),
      ],
    );
  }
}