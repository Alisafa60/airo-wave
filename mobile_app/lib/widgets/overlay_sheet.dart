import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';

void showEditOverlay(BuildContext context, int selectedContainerIndex, void Function() link) {
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
                              : 'Edit Respiratory Condition',
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
                    controller: TextEditingController(),
                    hintText: 'Allergen',
                  ),
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Severity',
                  ),
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Duration',
                  ),
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Triggers',
                  ),
                ],
              ),
            if (selectedContainerIndex == 3)
              Column(
                children: [
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Medication',
                  ),
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Dosage',
                  ),
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Frequency',
                  ),
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Start Date',
                  ),
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Health Condition',
                  ),
                ],
              ),
            if (selectedContainerIndex == 4)
              Column(
                children: [
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Condition',
                  ),
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Diagnosis',
                  ),
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Symptoms Frequency',
                  ),
                  UnderlineInputField(
                    controller: TextEditingController(),
                    hintText: 'Triggers',
                  ),
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
