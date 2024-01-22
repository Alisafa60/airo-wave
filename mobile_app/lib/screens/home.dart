import 'dart:async';
import 'package:mobile_app/requests/air_quality.dart';
import 'package:mobile_app/requests/environmental_survice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/api_service.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/requests/sensor_request.dart';
import 'package:mobile_app/utils/co2_voc_color.dart';
import 'package:mobile_app/widgets/bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.apiService});
  final ApiService apiService;
  
  @override
  State<HomeScreen> createState() => _MyHomeScreen();
}

class _MyHomeScreen extends State<HomeScreen> {
  late SensorService sensorService;
  Map<String, dynamic>? healthData;
  late Timer sensorUpdateTimer;
  late EnviromentalService enviromentalService;
  double latitude = 48.8566;
  double longitude = 2.3522;
  

  @override
  void initState() {
    super.initState();
    // sensorService = SensorService(widget.apiService);
    // _loadSensor();
    // sensorUpdateTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
    //   _loadSensor();
    // });
    enviromentalService = EnviromentalService(widget.apiService);
    _fetchAndPostAirQualityData();
  }

  @override
  void dispose() {
    sensorUpdateTimer.cancel();
    super.dispose();
  }

  Future<void> _loadSensor() async {
    try {
      final Map<String, dynamic> data = await sensorService.getSensorData();
      setState(() {
        healthData = data;
      });
     print(healthData);
    } catch (error) {
      print('Error loading health data: $error');
    }
  }
   Future<void> _fetchAndPostAirQualityData() async {
    try {

      await enviromentalService.fetchAirQualityDataAndPost(
        latitude,
        longitude,
      );
    } catch (error) {
      print('Error fetching and posting air quality data: $error');
    }
  }

  

  @override
  Widget build(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    int co2Value = healthData?['lastSensorData']?['co2'] ?? 0;
    int vocValue = healthData?['lastSensorData']?['voc'] ?? 0;

    Color statusColor = getStatusColor(
      co2Value > vocValue ? co2Value : vocValue,
      co2Value > vocValue ? 'co2' : 'voc',
    );

    String statusText = getStatusText(
      co2Value > vocValue ? co2Value : vocValue,
      co2Value > vocValue ? 'co2' : 'voc',
  );
  
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:  PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBar(
          backgroundColor:const Color.fromRGBO(255, 252, 252, 1),
          title: const Text(
            "Home",
            selectionColor: Color.fromRGBO(74, 74, 74, 1),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
          ),),
          centerTitle: true,
          leading: IconButton (
            icon: SvgPicture.asset('lib/assets/icons/add-circle.svg', height: 40, width: 40,),
           onPressed: () {
           },),
          actions: [
            IconButton(
              icon: SvgPicture.asset('lib/assets/icons/notification-bell.svg', height: 40, width: 40,), 
              onPressed: () { 
                _showNotificationOverlay(context);
              },
              )
          ],
        ),
      ),


      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              height: (screenHeight - appBarHeight - bottomNavBarHeight) * 0.38,
              color: const Color.fromRGBO(255, 252, 252, 1),
              child: Column(
                children: [
                  SizedBox(height: 12,),
                  Container(
                    
                    color: const Color.fromARGB(255, 211, 211, 211),
                    height: 1.5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    color: const Color.fromRGBO(255, 252, 252, 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            //route for user profile
                          },
                          child: ClipOval(
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
                        ),
                        // const SizedBox(width: 10), 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                            'Hello Ali, How are you doing today?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(74, 74, 74, 1),
                              )
                            ),
                            const SizedBox(width: 2,),
                            GestureDetector(
                              onTap: () {
                                //route to MedCat
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color.fromRGBO(255, 115, 19, 1),
                                  ),
                                  Text(
                                    'MedCat',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      color: Color.fromRGBO(255, 115, 19, 1),
                                    )
                                  )
                                ],
                              )
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    width: 360,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                      borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    width: 360,
                    height: 50,
                   decoration: BoxDecoration(
                    border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  )
                ],
              ),
            ),

            Container(
              height: (screenHeight - appBarHeight - bottomNavBarHeight) * 0.55,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                            children: [
                               Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                  'Indoor Air Quality',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: myGray.withOpacity(0.95)
                                  ),
                                  )
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      SvgPicture.asset('lib/assets/icons/carbon-dioxide.svg', height: 50, width: 50,),
                                      SizedBox(height: 10,),
                                      Text(
                                      '${healthData?['lastSensorData']?['co2'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: getStatusColor(
                                          healthData?['lastSensorData']?['co2'] ?? 0,
                                          'co2',
                                        ),
                                      ),
                                    ),
                                  ],
                                  ),
                                ),
                                Container(
                                  color: myGray.withOpacity(0.15),
                                  width: 3,
                                  height: 75, 
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          // border: Border.all(
                                          //   width: 2,
                                          //   color: myGray.withOpacity(0.15)
                                          // )
                                        ),
                                      child: Padding( 
                                        padding: EdgeInsets.all(7),
                                       child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                          'V',
                                            style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: myGray.withOpacity(1),
                                            ),
                                          ),
                                          SizedBox(width: 0,),
                                          SvgPicture.asset('lib/assets/icons/molecule.svg', height: 25, width: 25,),
                                          Text(
                                          'C',
                                            style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: myGray.withOpacity(1),
                                            ),
                                          ),
                                        ],
                                       ),
                                        ),
                                      ),
                                      SizedBox(height: 14),
                                      Text(
                                        '${healthData?['lastSensorData']?['voc'] ?? ''}', 
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: getStatusColor(
                                          healthData?['lastSensorData']?['voc'] ?? 0,
                                          'voc',
                                          )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(
                              height: 25,
                              width: (statusText == 'Good' || statusText == 'High') ? 60 : 80,
                              decoration: BoxDecoration(
                                color: statusColor,
                                border: Border.all(color: statusColor, width: 1),
                                borderRadius: BorderRadius.circular(15)
                                ),
                                child:  Center(
                                  child: Text(
                                  statusText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 179,
                          decoration: BoxDecoration(
                            border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                            borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                       Expanded(
                        child: Container(
                          height: 179,
                          decoration: BoxDecoration(
                            border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                            children: [
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                    Text(
                                      'Air Quality Index',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: myGray.withOpacity(0.95)
                                      ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: myGray.withOpacity(0.95)
                                      ),
                                      ),
                                  ],),
                                  
                                  SizedBox(width: 10,),
                                  Container(
                                  height: 20,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: const Center(
                                    child: Text(
                                    'Good',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                        Container(
                                          height: 30,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                                            borderRadius: BorderRadius.circular(15)
                                          ),
                                          child: const Center(
                                            child: Text(
                                            'CO',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: myGray,
                                              fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      SizedBox(height: 17,),
                                      Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        
                                      ),
                                    ),
                                  ],
                                  ),
                                ),
                                Container(
                                  color: myGray.withOpacity(0.15),
                                  width: 3,
                                  height: 75, 
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          // border: Border.all(
                                          //   width: 2,
                                          //   color: myGray.withOpacity(0.15)
                                          // )
                                        ),
                                      child: Padding( 
                                        padding: EdgeInsets.all(7),
                                       child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                        Container(
                                          height: 30,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                                            borderRadius: BorderRadius.circular(15)
                                          ),
                                          child: const Center(
                                            child: Text(
                                            'SO2',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: myGray,
                                              fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ],
                                       ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '', 
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: myGray.withOpacity(0.15),
                                  width: 3,
                                  height: 75, 
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 30,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                                            borderRadius: BorderRadius.circular(15)
                                          ),
                                          child: const Center(
                                            child: Text(
                                            'NO2',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: myGray,
                                              fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      SizedBox(height: 17,),
                                      Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        
                                      ),
                                    ),
                                  ],
                                  ),
                                ),
                                Container(
                                  color: myGray.withOpacity(0.15),
                                  width: 3,
                                  height: 75, 
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          // border: Border.all(
                                          //   width: 2,
                                          //   color: myGray.withOpacity(0.15)
                                          // )
                                        ),
                                      child: Padding( 
                                        padding: EdgeInsets.all(7),
                                       child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                         Container(
                                          height: 30,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                                            borderRadius: BorderRadius.circular(15)
                                          ),
                                          child: const Center(
                                            child: Text(
                                            'PM10',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: myGray,
                                              fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ],
                                       ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '', 
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 14,),
                             Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dominant Polutant',
                                  style: TextStyle(
                                    color: myGray,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '', 
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    
                                  ),
                                ),
                              ],
                            )
                          ]),
                          ),
                        ),
                      ),
                    ])
                ],
              )
            ),
          ],
        ),
      ),
       bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, 
     ),
    );
  }
   void _showNotificationOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200, // Adjust the height as needed
          child: Column(
            children: [
              // Add your notification content here
              ListTile(
                title: const Text('Notification 1'),
                onTap: () {
                  // Handle the tap on the first notification
                  Navigator.pop(context); // Close the overlay
                },
              ),
              ListTile(
                title: const Text('Notification 2'),
                onTap: () {
                  // Handle the tap on the second notification
                  Navigator.pop(context); // Close the overlay
                },
              ),
              // Add more notifications as needed
            ],
          ),
        );
      },
    );
  }
}
