
import 'package:flutter/material.dart';

class UserHealth extends StatefulWidget {
  const UserHealth({super.key});

  @override
  _UserHealthState createState() => _UserHealthState();
}

class _UserHealthState extends State<UserHealth> {
  TextEditingController bloodTypeController = TextEditingController();
  bool isBloodTypeValid = true;
  bool isValidBloodType(String bloodType) {
    List<String> validBloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    return validBloodTypes.contains(bloodType.toUpperCase());
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
            "Health",
            selectionColor: Color.fromRGBO(74, 74, 74, 1),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
          ),),
          centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(74, 74, 74, 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: IconButton(
              icon: const Icon(Icons.clear),
              color: const Color.fromRGBO(74, 74, 74, 1),
              onPressed: () {},
              iconSize: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(height: 100,),
                Expanded(
                    child: Container(
                    height: 40,
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    child: const TextField(
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: ' Weight',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(74, 74, 74, 0.4),
                        ),
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115 , 29, 0.6)), 
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.4)), 
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: bloodTypeController,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: ' Blood Type',
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(74, 74, 74, 0.4),
                        ),
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: isBloodTypeValid ? Color.fromRGBO(255, 115, 29, 0.6) : Colors.red,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: isBloodTypeValid ? Color.fromRGBO(74, 74, 74, 0.4) : Colors.red,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          isBloodTypeValid = isValidBloodType(value);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 10,),
            const Text(
              ' Health Condition',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(74, 74, 74, 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 14,),
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
      ),
    );
  }
}