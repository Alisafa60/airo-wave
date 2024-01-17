import 'package:flutter/material.dart';
import 'package:mobile_app/models/medication.model.dart';

class MedicationFields extends StatelessWidget {
  final int index;

  static final List<List<TextEditingController>> _fieldControllers = [[]];
  late String selectedHealthCondition;

   MedicationFields({super.key, required this.index}) : selectedHealthCondition = 'Allergy';

  MedicationData getMedicationData() {
    return MedicationData(
      medication: _fieldControllers[index][0].text,
      dosage: _fieldControllers[index][1].text,
      frequency: _fieldControllers[index][2].text,
      startDate: _fieldControllers[index][3].text,
      healthCondition: selectedHealthCondition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField('Medication', index, 0),
        _buildTextField('Dosage', index, 1),
        _buildTextField('Frequency', index, 2),
        _buildTextField('Start Date', index, 3),
        _buildHealthConditionDropdown(index),
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
        selectedHealthCondition = newValue!;
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




// class MedicationFieldsWidget extends StatelessWidget {
//   final String medicationEntry;
//   final int index;

//    MedicationFieldsWidget({super.key, required this.medicationEntry, required this.index});
//   final List<List<TextEditingController>> _fieldControllers = [[]];
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildTextField('Medication', index, 0),
//         _buildTextField('Dosage', index, 1),
//         _buildTextField('Frequency', index, 2),
//         _buildTextField('Start Date', index, 3),
//         _buildHealthConditionDropdown(index),
//       ],
//     );
//   }

//   Widget _buildTextField(String hintText, int index, int fieldIndex) {
//     TextEditingController controller;
//     while (_fieldControllers.length <= index) {
//       _fieldControllers.add([]);
//     }

//     if (fieldIndex >= _fieldControllers[index].length) {
//       controller = TextEditingController();
//       _fieldControllers[index].add(controller);
//     } else {
//       controller = _fieldControllers[index][fieldIndex];
//     }

//     return Container(
//       height: 50,
//       width: double.infinity,
//       padding: const EdgeInsets.all(5),
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       decoration: BoxDecoration(
//         // border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: hintText,
//           border: InputBorder.none,
//           focusedBorder:const UnderlineInputBorder(
//             borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115 , 29, 0.6)),
//           ),
//           enabledBorder: const UnderlineInputBorder(
//             borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.4)),
//           ),
//         ),
//       ),
//     );
//   }

//  Widget _buildHealthConditionDropdown(int index) {
//   List<String> healthConditions = [' Allergy', ' Respiratory Condition', ' Other'];

//   String selectedHealthCondition = healthConditions[0];

//   return DropdownButtonFormField<String>(
//     value: selectedHealthCondition,
//     onChanged: (newValue) {
//       setState(() {
//         selectedHealthCondition = newValue!;
//       });
//     },
//     items: healthConditions.map((condition) {
//       return DropdownMenuItem(
//         value: condition,
//         child: Text(condition),
//       );
//     }).toList(),
//     decoration: const InputDecoration(labelText: ' Medication for'),
//   );
// }
// }