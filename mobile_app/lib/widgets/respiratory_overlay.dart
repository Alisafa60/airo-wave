
import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';

showEditRespiratoryConditionOverlay(
  BuildContext context,
  TextEditingController conditionController,
  TextEditingController diagnosisController,
  TextEditingController symptomsFrequencyController,
  TextEditingController triggersController,
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
              'Edit Respiratory Condition',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                UnderlineInputField(
                  controller: conditionController,
                  hintText: 'Condition',
                ),
                SizedBox(height: 10,),
                UnderlineInputField(
                  controller: diagnosisController,
                  hintText: 'Diagnosis',
                ),
                SizedBox(height: 10,),
                UnderlineInputField(
                  controller: symptomsFrequencyController,
                  hintText: 'Symptoms Frequency',
                ),
                SizedBox(height: 10,),
                UnderlineInputField(
                  controller: triggersController,
                  hintText: 'Triggers',
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
