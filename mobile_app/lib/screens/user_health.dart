
import 'package:flutter/material.dart';

class UserHealth extends StatefulWidget {
  const UserHealth({Key? key}) : super(key: key);

  @override
  _UserHealthState createState() => _UserHealthState();
}

class _UserHealthState extends State<UserHealth> {
  List<DropdownMenuItem<String>> _conditionItems = [
    DropdownMenuItem(value: 'None', child: Text('None')),
    DropdownMenuItem(value: 'Allergy', child: Text('Allergy')),
    DropdownMenuItem(value: 'Respiratory Condition', child: Text('Respiratory Condition')),
    DropdownMenuItem(value: 'Other', child: Text('Other')),
  ];

  List<String> _selectedConditions = ['None'];
  List<List<TextEditingController>> _fieldControllers = [[]];
  TextEditingController _newFieldController = TextEditingController();

  TextEditingController bloodTypeController = TextEditingController();
  bool isBloodTypeValid = true;

  List<String> validBloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  bool isValidBloodType(String bloodType) {
    return validBloodTypes.contains(bloodType.toUpperCase());
  }

  List<bool> _isEditing = [];

  @override
  Widget build(BuildContext context) {
    _isEditing = List.generate(_selectedConditions.length, (index) => false);
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
                  SizedBox(height: 80,),
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
                            borderSide:
                                BorderSide(width: 2, color: Color.fromRGBO(255, 115, 29, 0.6)),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.4)),
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
              const SizedBox(height: 10),
              const Text(
                ' Health Condition',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromRGBO(74, 74, 74, 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 14),
              ExpansionPanelList(
                elevation: 1,
                expandedHeaderPadding: EdgeInsets.all(0),
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isEditing[index] = false;
                    _selectedConditions[index] =
                        isExpanded ? 'None' : _selectedConditions[index];
                  });
                },
                children: _selectedConditions.asMap().entries.map((entry) {
                  int index = entry.key;
                  String condition = entry.value;
                  bool isEditing = _isEditing[index];

                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return _buildConditionHeader(index, condition, _isEditing[index]);
                    },
                    body: Column(
                      children: [
                        if (_isEditing[index] || condition != 'None')
                          ..._buildFieldsForCondition(condition, index),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.save),
                              onPressed: () {
                                // Handle save logic here
                                setState(() {
                                  _isEditing[index] = false;
                                  _selectedConditions[index] =
                                      _selectedConditions[index] != 'None'
                                          ? _selectedConditions[index]
                                          : _conditionItems.first.value!;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Handle edit logic here
                                setState(() {
                                  _isEditing[index] = true;
                                  _selectedConditions[index] = condition;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    isExpanded: _isEditing[index] || condition != 'None',
                  );
                }).toList(),
              ),

              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  setState(() {
                    _isEditing.add(false);
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
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      const SizedBox(width: 10),
                      Text('Add Health Condition'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFieldsForCondition(String condition, int index) {
    List<Widget> fields = [];

    switch (condition) {
      case 'Allergy':
        fields = [
          _buildTextField('Allergen', index, 0),
          _buildTextField('Severity', index, 1),
          _buildTextField('Duration', index, 2),
          _buildTextField('Triggers', index, 3),
        ];
        break;
      case 'Respiratory Condition':
        fields = [
          _buildTextField('Condition', index, 0),
          _buildTextField('Diagnosis', index, 1),
          _buildTextField('Symptoms Frequency', index, 2),
          _buildTextField('Triggers', index, 3),
        ];
        break;
      case 'Other':
        fields = [_buildTextField('Other', index, 0)];
        break;
      default:
        break;
    }

    return fields;
  }

  Widget _buildTextField(String hintText, int conditionIndex, int fieldIndex) {
    TextEditingController controller;
    if (fieldIndex >= _fieldControllers[conditionIndex].length) {
      controller = TextEditingController();
      _fieldControllers[conditionIndex].add(controller);
    } else {
      controller = _fieldControllers[conditionIndex][fieldIndex];
    }

    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildConditionHeader(int index, String condition, bool isEditing) {
    if (isEditing) {
      // Render editable field for the first condition entered
      
      if (_fieldControllers[index].isNotEmpty) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                // Handle save logic here
                setState(() {
                  _isEditing[index] = false;
                  _selectedConditions[index] = 'None';
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Handle edit logic here
                setState(() {
                  _isEditing[index] = true;
                });
              },
            ),
          ],
        );
      } else {
        return Container(); // No fields to display
      }
    } else {
      return InkWell(
        onTap: () {
          setState(() {
            _isEditing[index] = false;
            _selectedConditions[index] =
                _selectedConditions[index] == 'None' ? condition : 'None';
          });
        },
        child: Container(
          height: 50,
          width: 100,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: _fieldControllers[index].isEmpty
              ? Row(
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
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _selectedConditions.removeAt(index);
                          _fieldControllers.removeAt(index);
                        });
                      },
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _fieldControllers[index][0],
                        decoration: InputDecoration(
                          hintText: condition,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () {
                        // Handle save logic for editable field
                        setState(() {
                          _isEditing[index] = false;
                          _selectedConditions[index] = condition;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Handle edit logic for editable field
                        setState(() {
                          _isEditing[index] = true;
                        });
                      },
                    ),
                  ],
                ),
        ),
      );
    }
  }
  void _updateFieldControllers(int index) {
    if (_fieldControllers[index].isEmpty) {
    _fieldControllers[index].add(TextEditingController());
  }
}
}
