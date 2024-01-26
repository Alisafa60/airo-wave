import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/api_service.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/requests/severity_service.dart';
import 'package:mobile_app/utils/image_helper.dart';
import 'package:mobile_app/widgets/bottom_bar.dart';

class MedCatScreen extends StatefulWidget {
  final ApiService apiService;
  const MedCatScreen({super.key, required this.apiService});

  @override

  State<MedCatScreen> createState() => _MedCatScreenState();
}

class _MedCatScreenState extends State<MedCatScreen> {
  bool isExpanded = false;
  int expandedContainerIndex = -1;
  late SeverityService severityService;
  String? fileName;
  
  void handleContainerTap (int index){
    setState(() {
      if (index == expandedContainerIndex){
        isExpanded = !isExpanded;
      }else {
        isExpanded = true;
        expandedContainerIndex = index;
      }
    });
  }

  void handleNumberCircleTap(int severity) {
    try {
      severityService.addSeverity(severity);
      print('Severity $severity added successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Severity $severity added successfully'),
          duration: const Duration(seconds: 2), 
        ),
      );
    } catch (error) {
      print('Error adding severity: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add severity. Please try again.'),
        ),
      );
    }
  }

  Future<void> _loadProfileImage() async {
    String? savedImagePath = await ImageHelper.loadProfileImage();
    if (savedImagePath != null) {
      setState(() {
        fileName = savedImagePath;
      });
      print('image path $fileName');
    }
  }

  @override
  void initState() {
    super.initState();
    severityService = SeverityService(widget.apiService);
    _loadProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
          "MedCat",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.black12,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: const Color.fromRGBO(255, 252, 252, 1),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              //route for user profile
                            },
                            child: ClipOval(
                              child: Container(
                                width: 70,
                                height: 70,
                                child: fileName != null
                                ? Image.network(
                                    'http://172.25.135.58:3000/uploads/$fileName',
                                    
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'lib/assets/images/profile-picture.png',
                                    fit: BoxFit.cover,
                                  ),
                            ),
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
                    const SizedBox(height: 20,),
                    Text(
                      ' How is your Allergy today?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(74, 74, 74, 1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                       child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (int i = 1; i <= 5; i++)
                              GestureDetector(
                                onTap: () {
                                  handleNumberCircleTap(i);
                                },
                                child: i == 1 || i == 5
                                    ? CircleAvatar(
                                        child: SvgPicture.asset(
                                          i == 1 ? 'lib/assets/icons/happy-circle.svg' : 'lib/assets/icons/sad-circle.svg',
                                          height: 38, width: 38,
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: const Color.fromRGBO(255, 117, 29, 0.7),
                                        child: Text(
                                          i.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black12,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                // Handle tap
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 117, 19, 1),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Show Analysis',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
            if (!isExpanded) {
              setState(() {
                isExpanded = true;
                expandedContainerIndex = -1;
              });
            }
          },
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! > 0 && isExpanded) {
              setState(() {
                isExpanded = false;
                expandedContainerIndex = -1;
              });
            }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: isExpanded ? MediaQuery.of(context).size.height * 0.67 : 245,
              width: 400,
              decoration: BoxDecoration(
                color: Color.fromARGB(170, 3, 4, 6),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 30,
                        ),
                        SvgPicture.asset(
                          'lib/assets/icons/MedCat-white.svg', 
                          height: 30,
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () => handleContainerTap(0),
                      child: Visibility(
                        visible: expandedContainerIndex == 0 || !isExpanded,
                        child: Container(
                          width: double.infinity,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all( color: secondaryColor, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              'Press me!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () => handleContainerTap(1),
                      child: Visibility(
                        visible: expandedContainerIndex == 1 || !isExpanded,
                        child: Container(
                          width: double.infinity,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all( color: secondaryColor, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              'Press meee!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isExpanded,
                      child: Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white, 
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Message MedCat...',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    // Handle send button press
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, 
     ),
    );
  }
}
