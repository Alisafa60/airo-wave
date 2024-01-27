import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';

showEditWeightOverlay(
  BuildContext context,
  TextEditingController weightController,
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
              'Update Weight',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                UnderlineInputField(
                  controller: weightController,
                  hintText: 'weight',
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