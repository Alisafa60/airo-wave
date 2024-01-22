import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/api_service.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/requests/allergy_survice.dart';
import 'package:mobile_app/requests/health_survice.dart';
import 'package:mobile_app/requests/medication_survice.dart';
import 'package:mobile_app/requests/respiratory_condition_survice.dart';
import 'package:mobile_app/widgets/allergy_overlay.dart';
import 'package:mobile_app/widgets/medication_overlay.dart';
import 'package:mobile_app/widgets/respiratory_overlay.dart';

class ShowHealthScreen extends StatefulWidget {
  const ShowHealthScreen({super.key, required this.apiService});
  final ApiService apiService;
  
  @override

  State<ShowHealthScreen> createState() => _ShowHealthScreenState();
}
 
class _ShowHealthScreenState extends State<ShowHealthScreen> {
  int selectedContainerIndex = -1;
  late HealthService healthService;
  late AllergySurvice allergySurvice;
  late RespiratoryConditionSurvice respiratorySurvice;
  late MedicationSurvice medicationSurvice;

  TextEditingController allergyNameController = TextEditingController();
  TextEditingController allergySeverityController = TextEditingController();
  TextEditingController allergyDurationController = TextEditingController();
  TextEditingController allergyTriggersController = TextEditingController();

  TextEditingController medicationController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TextEditingController startDateController = TextEditingController();

  TextEditingController respiratoryConditionController = TextEditingController();
  TextEditingController respiratoryDiagnosisController = TextEditingController();
  TextEditingController respiratorySymptomsFrequencyController = TextEditingController();
  TextEditingController respiratoryTriggersController = TextEditingController();

  Map<String, dynamic>? healthData;
  Map<String, dynamic>? allergyData;
  Map<String, dynamic>? respiratoryData;
  Map<String, dynamic>? medicationData;

  @override
  void initState() {
    super.initState();
    healthService = HealthService(widget.apiService);
    allergySurvice = AllergySurvice(widget.apiService); 
    respiratorySurvice = RespiratoryConditionSurvice(widget.apiService);
    medicationSurvice = MedicationSurvice(widget.apiService);
    _loadHealthData();
    _loadAllergy();
    _loadRespiratory();
    _loadMedication();
    
  }

  Future<void> _loadHealthData() async {
    try {
      final Map<String, dynamic> data = await healthService.getUserHealthData();
      setState(() {
        healthData = data;
      });
     print(healthData);
    } catch (error) {
      print('Error loading health data: $error');
    }
  }

  Future<void> _loadAllergy() async {
    try {
      final Map<String, dynamic> data = await allergySurvice.getAllergy();
      setState(() {
        allergyData = data;
      });
      print(allergyData);
    } catch (error) {
      print('Error loading health data: $error');
    }
  }

  Future<void> _loadRespiratory() async {
    try {
      final Map<String, dynamic> data = await respiratorySurvice.getRespiratoryCondition();
      setState(() {
        respiratoryData = data;
      });
      print(respiratoryData);
    } catch (error) {
      print('Error loading health data: $error');
    }
  }

  Future<void> _loadMedication() async {
    try {
      final Map<String, dynamic> data = await medicationSurvice.getMedication();
      setState(() {
        medicationData = data;
      });
    } catch (error) {
      print('Error loading health data: $error');
    }
  }

  List<Widget> buildAllergenWidgets(Map<String, dynamic>? allergyData) {
    if (allergyData!.containsKey('allergies') && allergyData!['allergies'] is List) {
      List<Map<String, dynamic>> allergies = List<Map<String, dynamic>>.from(allergyData['allergies']);

      return allergies.map((allergy) {
        return Padding(
          padding: EdgeInsets.only(right: 10),
          child: Container(
            height: 30,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: myGray.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.circular(15)
            ),
           child: Center(
              child: Text(
              '${allergy['allergen']}',
              style: TextStyle(
                fontSize: 16,
                color: myGray.withOpacity(0.8),
                fontWeight: FontWeight.w400,
            ),
              ),
          ),
          )
        );
      }).toList();
    } else {
      return [];
    }
  }
  
  List<Widget> buildRespiratoryWidgets(Map<String, dynamic>? respiratoryData) {
    if (respiratoryData!.containsKey('respiratoryConditions') && respiratoryData!['respiratoryConditions'] is List) {
      List<Map<String, dynamic>> respiratoryConditions = List<Map<String, dynamic>>.from(respiratoryData['respiratoryConditions']);

      return respiratoryConditions.map((respiratoryCondition) {
        return Padding(
          padding: EdgeInsets.only(right: 10),
          child: Container(
            height: 30,
            width: 100,
           decoration: BoxDecoration(
              border: Border.all(color: myGray.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.circular(15)
            ),
           child: Center(
              child: Text(
              '${respiratoryCondition['condition']}',
              style: TextStyle(
                fontSize: 16,
                color: myGray.withOpacity(0.8),
                fontWeight: FontWeight.w400,
            ),
              ),
          ),
          )
        );
      }).toList();
    } else {
      return [];
    }
  }

  List<Widget> buildMedicationWidgets(Map<String, dynamic>? medicationData) {
    if (medicationData!.containsKey('medications') && medicationData!['medications'] is List) {
      List<Map<String, dynamic>> medications = List<Map<String, dynamic>>.from(medicationData['medications']);

      return medications.map((medication) {
        return Padding(
          padding: EdgeInsets.only(right: 10),
          child: Container(
            height: 30,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: myGray.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.circular(15)
            ),
           child: Center(
              child: Text(
              '${medication['name']}',
              style: TextStyle(
                fontSize: 16,
                color: myGray.withOpacity(0.8),
                fontWeight: FontWeight.w400,
            ),
              ),
          ),
          )
        );
      }).toList();
    } else {
      return [];
    }
  }

  Future<void> updateAllergy({
    required String allergen,
    String? severity,
    String? duration,
    String? triggers,
  }) async {
    try {
      final Map<String, dynamic> updatedAllergy = await allergySurvice.updateAllergyByName(
        allergen: allergen,
        severity: severity,
        duration: duration,
        triggers: triggers,
      );

      print('Allergy Updated: $updatedAllergy');
      
      await _loadAllergy();
    } catch (error) {
      print('Error updating allergy: $error');
    }
  }

  Future<void> updateMedication({
    required String name,
    String? dosage,
    String? frequency,
    String? startDate,
  }) async {
    try {
      final Map<String, dynamic> updatedMedication = await medicationSurvice.updateMedication(
        name: name,
        dosage: dosage,
        frequency: frequency,
        startDate: startDate,
      );

      print('Medication Updated: $updatedMedication');

      await _loadMedication();
    } catch (error) {
      print('Error updating medication: $error');
    }
  }

Future<void> updateRespiratoryCondition({
    required String condition,
    String? diagnosis,
    String? symptomsFrequency,
    String? triggers,
  }) async {
    try {
      final Map<String, dynamic> updateRespiratoryCondition = await respiratorySurvice.updateRespiratoryCondition(
        condition: condition,
        diagnosis: diagnosis,
        symptomsFrequency: symptomsFrequency,
        triggers: triggers,
      );

      print('Medication Updated: $updateRespiratoryCondition');

      await _loadMedication();
    } catch (error) {
      print('Error updating medication: $error');
    }
  }
  
  

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
          "Health",
          selectionColor: Color.fromRGBO(74, 74, 74, 1),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          padding: EdgeInsets.all(15),
          icon: Icon(Icons.arrow_back_ios, color: myGray),
          onPressed: () {},
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.black12,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              height: 100,
              alignment: Alignment.center,
              color: const Color.fromRGBO(255, 252, 252, 1),
              child: Column(
                children: [
               
                  GestureDetector(
                    onTap: () {
                      //route for user profile
                    },
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('lib/assets/images/profile-picture.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.edit_note,
                                size: 25,
                                color: myGray.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  const Text(
                    'Ali Safa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(74, 74, 74, 1),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedContainerIndex = 0;
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: myGray.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                            child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.bloodtype_outlined,
                                size: 30,
                                color: Colors.red.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.edit_note,
                                size: 30,
                                color: myGray.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                        if (healthData != null &&
                          healthData!.containsKey('userHealth') &&
                          healthData!['userHealth']!.containsKey('bloodType'))
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Text(
                            'Blood Type ${healthData!['userHealth']!['bloodType']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: myGray.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedContainerIndex = 1;
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: myGray.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: SvgPicture.asset(
                                'lib/assets/icons/weight.svg',
                                height: 27,
                                width: 27,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                             
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.edit_note,
                                size: 30,
                                color: myGray.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                        if (healthData != null &&
                          healthData!.containsKey('userHealth') &&
                          healthData!['userHealth']!.containsKey('weight'))
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Text(
                            'Weight ${healthData!['userHealth']!['weight']}Kg',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: myGray.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedContainerIndex = 2;
                });
                
              },
              child: Stack(
                children: [
                  Container(
                    height: 124,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: myGray.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: 
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          'lib/assets/icons/leaf.svg',
                          height: 32,
                          width: 32,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        showEditAllergyOverlay(
                          context,
                          allergyNameController,
                          allergySeverityController,
                          allergyDurationController,
                          allergyTriggersController,
                          () async {
                            String allergen = allergyNameController.text;
                            String severity = allergySeverityController.text;
                            String duration = allergyDurationController.text;
                            String triggers = allergyTriggersController.text;

                            await updateAllergy(
                              allergen: allergen,
                              severity: severity,
                              duration: duration,
                              triggers: triggers,
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.edit_note,
                          size: 30,
                          color: myGray.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' Allergy',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: myGray.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 6,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: buildAllergenWidgets(allergyData),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedContainerIndex = 3;
                });
              },
              child: Stack(
                children: [
                  Container(
                    height: 124,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: myGray.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: 
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          'lib/assets/icons/lungs.svg',
                          height: 37,
                          width: 38,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                    
                        showEditRespiratoryConditionOverlay(
                        context,
                        respiratoryConditionController,
                        respiratoryDiagnosisController,
                        respiratorySymptomsFrequencyController,
                        respiratoryTriggersController,
                        () async {
                          String condition = respiratoryConditionController.text;
                          String diagnosis = respiratoryDiagnosisController.text;
                          String symptomsFrequency = respiratorySymptomsFrequencyController.text;
                          String triggers = respiratoryTriggersController.text;
                          await updateRespiratoryCondition(
                            condition: condition,
                            diagnosis: diagnosis,
                            symptomsFrequency: symptomsFrequency,
                            triggers: triggers,
                          );

                        },
                      );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.edit_note,
                          size: 30,
                          color: myGray.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                   Positioned(
                    bottom: 15,
                    left: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' Respiratory Condition',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: myGray.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 6,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: buildRespiratoryWidgets(respiratoryData),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedContainerIndex = 4;
                });
              },
              child: Stack(
                children: [
                  Container(
                    height: 124,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: myGray.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: 
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          'lib/assets/icons/pill.svg',
                          height: 23,
                          width: 23,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        showEditMedicationOverlay(
                          context,
                          medicationController,
                          dosageController,
                          frequencyController,
                          startDateController,
                          () async {
                            String name = medicationController.text;
                            String dosage = dosageController.text;
                            String frequency = frequencyController.text;
                            String startDate = startDateController.text;

                            await updateMedication(
                              name: name,
                              dosage: dosage,
                              frequency: frequency,
                              startDate: startDate,
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.edit_note,
                          size: 30,
                          color: myGray.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                   Positioned(
                    bottom: 15,
                    left: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' Medications',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: myGray.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 6,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: buildMedicationWidgets(medicationData),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/home-filled.svg',
              height: 35, width: 35,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/MedCat.svg',
              height: 35, width: 35,),
            label: 'MedCat',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/map-location.svg',
              height: 35, width: 35,),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/activity-waves.svg',
              height: 35, width: 35,),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/community.svg',
              height: 35, width: 35,),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}
