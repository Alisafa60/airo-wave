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
  int initialMedicationCount = 30;

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
  ScrollController _scrollController = ScrollController();
  List<String> medicationEntries = [];
  List<GlobalKey<MedicationFieldsState>> medicationFieldsKeys = [];

  bool isBloodTypeValid = true;
  List<String> validBloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  bool isValidBloodType(String bloodType) {
    return validBloodTypes.contains(bloodType.toUpperCase());
  }

  double _saveButtonOpacity = 1.0;
  bool isSaveButtonVisible = true;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
     _scrollController = ScrollController();
     for (int i = 0; i < initialMedicationCount; i++) {
    medicationFieldsKeys.add(GlobalKey<MedicationFieldsState>());
    }
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
      
      try {
        final http.Response response = await widget.apiService.post(
          '/api/user/health',
          headers,
          requestBody
        );
        if (response.statusCode == 201) {
          print('Profile update successful');
          
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
      final Map<String, String> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
      AllergyData allergyData = const AllergyFields(index: 0).getAllergyData();

      if (allergyData.allergen.isNotEmpty) {
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
      } else {
        print('Skipping allergy due to missing field');
      }
    }
  }

  Future<void> addMedication() async {
    String? token = await getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      for (int i = 0; i < medicationEntries.length; i++) {
        MedicationFieldsState medicationFieldsState = medicationFieldsKeys[i].currentState!;
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

          if (response.statusCode == 201) {
            print('medication added succesfuly');
          } else {
            print('Medication addition failed. Status code: ${response.statusCode}, Body: ${response.body}');
          }
        } catch (error) {
          print('Error during medication addition: $error');
        }
      }
    }
  }
  Future<void> addRespiratoryCondition() async {
    String? token = await getToken();

    if (token != null) {
      final Map<String, String> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
      RespiratoryConditionData respiratoryConditionData = RespiratoryConditionFields(index: 0).getRespiratoryConditionData();

      if (respiratoryConditionData.condition.isNotEmpty) {
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
      } else {
        print('Skipping respiratory condition due to missing fields');
      }
    }
  }
  
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
    
    ),
    body: NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollUpdateNotification) {
          setState(() {
            _saveButtonOpacity = scrollInfo.scrollDelta! < 0 ? 0.2 : 1.0;
          });
        }
        return false;
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
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
                          key: medicationFieldsKeys[i], 
                          index: i,
                        ),
                    ],
                  ),
                  const SizedBox(height: 70,),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: _saveButtonOpacity,
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(15),
              child: SaveButton(
                buttonText: 'Save',
                onPressed: () async {
                 await Future.wait([
                  addHealthCondition(),
                  addAllergyCondition(),
                  addRespiratoryCondition(),
                  addMedication(),
                  Navigator.pushReplacementNamed(context, '/home')
                ]);
                
                },
              ),
              ),
            ),
          ),
        ],
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
