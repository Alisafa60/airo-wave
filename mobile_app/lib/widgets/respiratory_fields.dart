import 'package:flutter/material.dart';
import 'package:mobile_app/models/respiratory_condition.model.dart';

class RespiratoryConditionFields extends StatelessWidget {
  final int index;
  static final List<List<TextEditingController>> _fieldControllers = [[]];
  RespiratoryConditionFields({super.key, required this.index});

  RespiratoryConditionData getRespiratoryConditionData() {
    print('Condition: ${_fieldControllers[index][0].text}');
    print('Diagnosis: ${_fieldControllers[index][1].text}');
    print('Symptoms Frequency: ${_fieldControllers[index][2].text}');
    print('Triggers: ${_fieldControllers[index][3].text}');

    return RespiratoryConditionData(
      condition: _fieldControllers[index][0].text,
      diagnosis: _fieldControllers[index][1].text,
      symptomsFrequency: _fieldControllers[index][2].text,
      triggers: _fieldControllers[index][3].text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField('Condition', index, 0),
        _buildTextField('Diagnosis', index, 1),
        _buildTextField('Symptoms Frequency', index, 2),
        _buildTextField('Triggers', index, 3),
      ],
    );
  }

  Widget _buildTextField(String hintText, int index, int fieldIndex) {
    TextEditingController controller;

    while (_fieldControllers.length <= index) {
      _fieldControllers.add([]);
    }

    if (fieldIndex >= _fieldControllers[index].length) {
      controller = TextEditingController();
      _fieldControllers[index].add(controller);
    } else {
      controller = _fieldControllers[index][fieldIndex];
    }

    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115 , 29, 0.6)),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.4)),
          ),
        ),
      ),
    );
  }
}

