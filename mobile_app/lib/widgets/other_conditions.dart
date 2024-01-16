import 'package:flutter/material.dart';

class OtherFields extends StatelessWidget {
  final int index;

  OtherFields({super.key, required this.index});
  final List<List<TextEditingController>> _fieldControllers = [[]];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField('Other', index, 0),
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
        // border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          focusedBorder:const UnderlineInputBorder(
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
