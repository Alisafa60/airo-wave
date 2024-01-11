import 'package:flutter/material.dart';

class DraggableSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.7,
      initialChildSize: 0.1,
      minChildSize: 0.1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      hintText: '...Ask MedCat',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(74, 74, 74, 0.4),
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      height: 1.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Expanded Content Here',
                    style: TextStyle(
                      color: Color.fromRGBO(74, 74, 74, 1),
                    ),
                  ),
                )
                ],
              ),
            ),
        );
      }
    );
  }
}