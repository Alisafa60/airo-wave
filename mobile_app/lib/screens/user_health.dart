import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/allergy.model.dart';
import 'package:mobile_app/models/medication.model.dart';
import 'package:mobile_app/models/respiratory_condition.model.dart';
import 'package:mobile_app/widgets/allergy_fields.dart';
import 'package:mobile_app/widgets/health_conditions.dart';
import 'package:mobile_app/widgets/medications.dart';
import 'package:mobile_app/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/widgets/respiratory_fields.dart';

class UserHealthScreen extends StatefulWidget {
  final ApiService apiService;
  const UserHealthScreen({super.key, required this.apiService});
  
  @override
  State<UserHealthScreen> createState() => _UserHealthState();
  
}

class _UserHealthState extends State<UserHealthScreen> {
  GlobalKey<MedicationFieldsState> medicationFieldsKey = GlobalKey<MedicationFieldsState>();


  final List<DropdownMenuItem<String>> _conditionItems = [
    const DropdownMenuItem(value: 'None', child: Text('None')),
    const DropdownMenuItem(value: 'Allergy', child: Text('Allergy')),
    const DropdownMenuItem(value: 'Respiratory Condition', child: Text('Respiratory Condition')),
    const DropdownMenuItem(value: 'Other', child: Text('Other')),
  ];

  final List<String> _selectedConditions = ['None'];
  final List<List<TextEditingController>> _fieldControllers = [[]];
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  List<String> medicationEntries = [];

  bool isBloodTypeValid = true;
  List<String> validBloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  bool isValidBloodType(String bloodType) {
    return validBloodTypes.contains(bloodType.toUpperCase());
  }

  Future<String?> getToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: 'jwtToken');
  }

  Future<void> addHealthCondition() async {
    String? token = await getToken();
    final int weight = int.tryParse(weightController.text) ?? 0;
    final String bloodType = bloodTypeController.text;
  
    if (token!=null){
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
         'Content-Type': 'application/json'
        };
      final Map<String, dynamic> requestBody = {
        'weight': weight,
        'bloodType': bloodType,
      };
      print(requestBody);
      print(headers);

      try {
        final http.Response response = await widget.apiService.post(
          '/api/user/health',
          headers,
          requestBody
        );
        if (response.statusCode == 201) {
          print('Profile update successful');
          print(requestBody);
          
        } else {
          print('Profile update failed. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } catch (error) {
        print('Error during profile update: $error');
      }
    }
  }
 
  Future<void> addAllergyCondition() async {
    String? token = await getToken();
    
    if (token != null) {
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
         'Content-Type': 'application/json'
        };
      AllergyData allergyData = const AllergyFields(index: 0).getAllergyData();

      final Map<String, dynamic> requestBody = {
        'allergen': allergyData.allergen,
        'severity': allergyData.severity,
        'duration': allergyData.duration,
        'triggers': allergyData.triggers,
      };

      try {
        final http.Response response = await widget.apiService.post(
          '/api/user/health/allergy',
          headers,
          requestBody,
        );

        print(requestBody);

        if (response.statusCode == 201) {
          print('Allergy conditions added successfully');
          print(requestBody);
        } else {
          print('Allergy condition addition failed. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } catch (error) {
        print('Error during allergy condition addition: $error');
      }
    }
  }
  Future<void> addMedication() async {
    String? token = await getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      MedicationFieldsState medicationFieldsState = medicationFieldsKey.currentState!;
      MedicationData medicationData = medicationFieldsState.getMedicationData();

      final Map<String, dynamic> requestBody = {
        'name': medicationData.medication,
        'dosage': medicationData.dosage,
        'frequency': medicationData.frequency,
        'startDate': medicationData.startDate,
        'context': medicationData.healthCondition,
      };

      try {
        final http.Response response = await widget.apiService.post(
          '/api/user/health/medication',
          headers,
          requestBody,
        );

        print(requestBody);

        if (response.statusCode == 201) {
          print('Medication added successfully');
          print(requestBody);
        } else {
          print('Medication addition failed. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } catch (error) {
        print('Error during medication addition: $error');
      }
    }
  }

  Future<void> addRespiratoryCondition() async {
    String? token = await getToken();
    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
      RespiratoryConditionData respiratoryConditionData = RespiratoryConditionFields(index: 0).getRespiratoryConditionData();
      
      final Map<String, dynamic> requestBody = {
        'condition': respiratoryConditionData.condition,
        'diagnosis': respiratoryConditionData.diagnosis,
        'symptomsFrequency': respiratoryConditionData.symptomsFrequency,
        'triggers': respiratoryConditionData.triggers,
      };

      try {
        final http.Response response = await widget.apiService.post(
          '/api/user/health/respiratoryCondition',
          headers,
          requestBody,
        );

        print(requestBody);

        if (response.statusCode == 201) {
          print('Respiratory conditions added successfully');
          print(requestBody);
        } else {
          print('Respiratory condition addition failed. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } catch (error) {
        print('Error during respiratory condition addition: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
          "Health",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(height: 80,),
                  Expanded(
                   child: UnderlineInputField(hintText: 'Weight', controller: weightController,)
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: UnderlineInputField(
                      controller: bloodTypeController,
                      hintText: ' Blood Type',
                      // onChanged: (value) {
                      //   setState(() {
                      //     isBloodTypeValid = isValidBloodType(value);
                      //   });
                      // },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                ' Health Condition',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromRGBO(74, 74, 74, 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              ExpansionPanelList(
                elevation: 1,
                expandedHeaderPadding: const EdgeInsets.all(0),
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _selectedConditions[index] = isExpanded ? 'None' : _selectedConditions[index];
                  });
                },
                children: _selectedConditions.asMap().entries.map((entry) {
                  int index = entry.key;
                  String condition = entry.value;

                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedConditions[index] = !isExpanded ? 'None' : 'None';
                          });
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              DropdownButton<String>(
                                value: condition,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedConditions[index] = value!;
                                    _updateFieldControllers(index);
                                  });
                                },
                                items: _conditionItems,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _selectedConditions.removeAt(index);
                                    _fieldControllers.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    body: HealthConditionFieldsWidget(condition: condition, index: index),
                    isExpanded: condition != 'None',
                  );
                }).toList(),
              ),

              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedConditions.add('None');
                    _fieldControllers.add([TextEditingController()]);
                  });
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text('Add Health Condition'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    ' Medications',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(74, 74, 74, 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              medicationEntries.add('New Medication');
                            });
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 10),
                                Text('Add Medication'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          if (medicationEntries.isNotEmpty) {
                            setState(() {
                              medicationEntries.removeLast();
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 10),
                              Text('Delete Medication'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0; i < medicationEntries.length; i++)
                    MedicationFields(
                      key: medicationFieldsKey, // Pass the GlobalKey here
                      index: i,
                    ),
                ],
              ),
              const SizedBox(height: 40,),
              SaveButton(
                  buttonText: 'Save',
                  onPressed: addMedication,
              )
            ],  
          ),
        ),
      ),
    );
  }

  void _updateFieldControllers(int index) {
    _fieldControllers[index].forEach((controller) {
      controller.clear();
    });
  }
}
