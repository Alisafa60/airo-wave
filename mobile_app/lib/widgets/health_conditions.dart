import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/allergy_fields.dart';
import 'package:mobile_app/widgets/other_conditions.dart';
import 'package:mobile_app/widgets/respiratory_fields.dart';


class HealthConditionFieldsWidget extends StatelessWidget {
  final String condition;
  final int index;

  const HealthConditionFieldsWidget({super.key, required this.condition, required this.index});

  @override
  Widget build(BuildContext context) {
    // Switch statement for building fields based on condition
    switch (condition) {
      case 'Allergy':
        return AllergyFields(index: index);
      case 'Respiratory Condition':
        return RespiratoryConditionFields(index: index);
      case 'Other':
        return OtherFields(index: index);
      default:
        return Container(); // Placeholder, you can customize as needed
    }
  }
}