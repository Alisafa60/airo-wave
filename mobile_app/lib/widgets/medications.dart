import 'package:flutter/material.dart';
import 'package:mobile_app/models/medication.model.dart';

class MedicationFields extends StatefulWidget {
  final int index;
  
  const MedicationFields({super.key, required this.index});

  @override
  State<MedicationFields> createState() => MedicationFieldsState();
}

class MedicationFieldsState extends State<MedicationFields> {
  final List<List<TextEditingController>> _fieldControllers = [[]];
  late String selectedHealthCondition;

  @override
  void initState() {
    super.initState();
    while (_fieldControllers.length <= widget.index) {
      _fieldControllers.add([]);
    }
    selectedHealthCondition = 'Allergy';
  }

  MedicationData getMedicationData() {
    return MedicationData(
      medication: _fieldControllers[widget.index][0].text,
      dosage: _fieldControllers[widget.index][1].text,
      frequency: _fieldControllers[widget.index][2].text,
      startDate: _fieldControllers[widget.index][3].text,
      healthCondition: selectedHealthCondition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField('Medication', widget.index, 0),
        _buildTextField('Dosage', widget.index, 1),
        _buildTextField('Frequency', widget.index, 2),
        _buildTextField('Start Date', widget.index, 3),
        _buildHealthConditionDropdown(widget.index),
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
            borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115, 29, 0.6)),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.4)),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthConditionDropdown(int index) {
    List<String> healthConditions = ['Allergy', 'Respiratory Condition', 'Other'];

    return DropdownButtonFormField<String>(
      value: selectedHealthCondition,
      onChanged: (newValue) {
        setState(() {
          selectedHealthCondition = newValue!;
        });
      },
      items: healthConditions.map((condition) {
        return DropdownMenuItem(
          value: condition,
          child: Text(condition),
        );
      }).toList(),
      decoration: const InputDecoration(labelText: 'Medication for'),
    );
  }
}
