import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';

void showEditAllergyOverlay(
  BuildContext context,
  TextEditingController allergenController,
  TextEditingController severityController,
  TextEditingController durationController,
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
              'Edit Allergy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
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