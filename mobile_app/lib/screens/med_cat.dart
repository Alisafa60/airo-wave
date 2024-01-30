import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/api_service.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/requests/chatbot_service.dart';
import 'package:mobile_app/requests/profile.dart';
import 'package:mobile_app/requests/severity_service.dart';
import 'package:mobile_app/widgets/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late ProfileService profileService;
  late OpenAiService openAiService;
  String? fileName;
  Map<String, dynamic>? profileData;
  Map<String, dynamic>? chatbotResponse;
  Map<String, dynamic>? severityData;
  String openAiResponse = '';
  String openAiUserMessage_1 = "What's my health recommendation for today?";
  String openAiUserMessage_2 = "I'm going out, should I take any measures?";
  bool isLoading = false;
  bool isOverlayOpen = false;
  
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

  void toggleOverlay() {
    setState(() {
      isOverlayOpen = !isOverlayOpen;
    });
  }

  void handleNumberCircleTap(int severity) {
    try {
      severityService.addSeverity(severity);
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
  
  Future<void> _loadProfile() async {
    try {
      final Map<String, dynamic> data = await profileService.getProfile();
      setState(() {
        profileData = data;
      });
    } catch (error) {
      print('Error loading health data: $error');
    }
  }
     
  @override
  void initState() {
    super.initState();
    severityService = SeverityService(widget.apiService);
    profileService = ProfileService(widget.apiService);
    openAiService = OpenAiService(widget.apiService);
    _initializeProfileData();
    _loadSeverity();
  }

   Future<void> _initializeProfileData() async {
      await _loadProfile();
      await _loadProfileImage();
    }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = profileData?['user']?['id'].toString() ?? '';
    String key = 'profileImagePath_$userId';

    String? savedImagePath = prefs.getString(key);
    if (savedImagePath != null){
      setState(() {
        fileName = savedImagePath;
      });
    }
  }

  Future<void> _loadChatbotResponse() async {
      try {
        final Map<String, dynamic> data = await openAiService.getChatbotResponse();
        setState(() {
          chatbotResponse = data;
        });
      } catch (error) {
        print('Error loading chatbot response: $error');
      }
  }

   Future<void> _loadSeverity() async {
      try {
        final Map<String, dynamic> data = await severityService.getSeverity();
        setState(() {
          severityData = data;
        });
        print(severityData?['dailyHealth'][0]['severity']);
      } catch (error) {
        print('Error loading chatbot response: $error');
      }
    }


  Future<void> fetchOpenAiResponse(String userMessage) async {
    try {
      final Map<String, dynamic> response = await openAiService.sendToOpenAI(userMessage);
      setState(() {
        openAiResponse = response.toString();
      });
    } catch (error) {
      print('Error fetching OpenAI response: $error');
    }
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
                          Text(
                            '${profileData?['user']?['firstName']} ${profileData?['user']?['lastName']}',
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
                      ' How are you feeling today?',
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
                                  'Analysis',
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
          Stack(
          children: [
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
                  child: SingleChildScrollView(
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
                          onTap: () async {
                            handleContainerTap(0);
                            setState(() {
                              isLoading = true;
                            });
                            await fetchOpenAiResponse(openAiUserMessage_1);
                            await Future.delayed(Duration(seconds: 1));
                            _loadChatbotResponse();

                            setState(() {
                              isLoading = false;
                            });
                            
                          },
                          child: Visibility(
                            visible: expandedContainerIndex == 0 || !isExpanded,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: secondaryColor, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      openAiUserMessage_1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10,),
                                Visibility(
                                  visible: expandedContainerIndex == 0 && isExpanded,
                                  child: Container(
                                    width: 320,
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   border: Border.all(color: secondaryColor, width: 2),
                                    // ),
                                    child: Center(
                                      child: Text(
                                        '${chatbotResponse?['openAiResponse']?['response']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                            onTap: () async {
                              handleContainerTap(0);
                              setState(() {
                                isLoading = true;
                              });
                              await fetchOpenAiResponse(openAiUserMessage_1);
                              await Future.delayed(Duration(seconds: 4));
                              _loadChatbotResponse();

                              setState(() {
                                isLoading = false;
                              });
                              
                            },
                          child: Visibility(
                            visible: expandedContainerIndex == 1 || !isExpanded,
                            child: Container(
                              width: double.infinity,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: secondaryColor, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  openAiUserMessage_2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
            ),
            Positioned(
              bottom: 5,
              left: 10,
              right: 10,
              child: Visibility(
                visible: isExpanded,
                child: Container(
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        ],
      ),
    bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, 
     ),
    );
  }
}
