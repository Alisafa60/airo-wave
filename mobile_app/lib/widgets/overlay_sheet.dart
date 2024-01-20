import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';

void showEditOverlay(
  BuildContext context,
  int selectedContainerIndex,
  TextEditingController allergenController,
  TextEditingController severityController,
  TextEditingController durationController,
  TextEditingController triggersController,
  TextEditingController medicationController,
  TextEditingController dosageController,
  TextEditingController frequencyController,
  TextEditingController startDateController,
  TextEditingController conditionController,
  TextEditingController diagnosisController,
  TextEditingController symptomsFrequencyController,
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
              selectedContainerIndex == 0
                  ? 'Edit Blood Type'
                  : selectedContainerIndex == 1
                      ? 'Edit Weight'
                      : selectedContainerIndex == 2
                          ? 'Edit Allergy'
                          : selectedContainerIndex == 3
                              ? 'Edit Medication'
                              : selectedContainerIndex == 4
                                  ? 'Edit Respiratory Condition'
                                  : 'Invalid Option',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            if (selectedContainerIndex == 0 || selectedContainerIndex == 1)
              UnderlineInputField(
                controller: TextEditingController(),
                hintText: 'Enter new value',
              ),
            if (selectedContainerIndex == 2)
              Column(
                children: [
                  UnderlineInputField(
                    controller: allergenController,
                    hintText: 'Allergen',
                  ),
                  SizedBox(height: 10,),
                  UnderlineInputField(
                    controller: severityController,
                    hintText: 'Severity',
                  ),
                  SizedBox(height: 10,),
                  UnderlineInputField(
                    controller: durationController,
                    hintText: 'Duration',
                  ),
                  SizedBox(height: 10,),
                  UnderlineInputField(
                    controller: triggersController,
                    hintText: 'Triggers',
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            if (selectedContainerIndex == 3)
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
            if (selectedContainerIndex == 4)
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
