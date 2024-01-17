import 'package:flutter/material.dart';
import 'package:mobile_app/models/allergy.model.dart';

class AllergyFields extends StatelessWidget {
  final int index;

  // Move _fieldControllers outside the widget
  static final List<List<TextEditingController>> _fieldControllers = [[]];

  AllergyFields({super.key, required this.index});
  AllergyData getAllergyData() {
    print('Allergen: ${_fieldControllers[index][0].text}');
    print('Severity: ${_fieldControllers[index][1].text}');
    print('Duration: ${_fieldControllers[index][2].text}');
    print('Triggers: ${_fieldControllers[index][3].text}');
    return AllergyData(
      allergen: _fieldControllers[index][0].text,
      severity: _fieldControllers[index][1].text,
      duration: _fieldControllers[index][2].text,
      triggers: _fieldControllers[index][3].text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField('Allergen', index, 0),
        _buildTextField('Severity', index, 1),
        _buildTextField('Duration', index, 2),
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

    // Print controller's text value for debugging
    print('Text for $hintText (index: $index, fieldIndex: $fieldIndex): ${controller.text}');

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
