import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';

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