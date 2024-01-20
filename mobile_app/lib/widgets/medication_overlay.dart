import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';


void showEditMedicationOverlay(
  BuildContext context,
  TextEditingController medicationController,
  TextEditingController dosageController,
  TextEditingController frequencyController,
  TextEditingController startDateController,
  void Function() link,
) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Medication',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                UnderlineInputField(
                  controller: medicationController,
                  hintText: 'Medication',
                ),
                SizedBox(height: 10,),
                UnderlineInputField(
                  controller: dosageController,
                  hintText: 'Dosage',
                ),
                SizedBox(height: 10,),
                UnderlineInputField(
                  controller: frequencyController,
                  hintText: 'Frequency',
                ),
                SizedBox(height: 10,),
                UnderlineInputField(
                  controller: startDateController,
                  hintText: 'Start Date',
                ),
                SizedBox(height: 10,),
              ],
            ),
            SizedBox(height: 20),
            SaveButton(
              buttonText: 'Save',
              onPressed: link,
            ),
          ],
        ),
      );
    },
  );
}
