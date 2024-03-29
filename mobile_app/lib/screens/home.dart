import 'dart:async';
import 'package:mobile_app/requests/environmental_survice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/api_service.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/requests/location.service.dart';
import 'package:mobile_app/requests/pollen_service.dart';
import 'package:mobile_app/requests/profile.dart';
import 'package:mobile_app/requests/save_allergen.dart';
import 'package:mobile_app/requests/sensor_request.dart';
import 'package:mobile_app/utils/allergens_info.dart';
import 'package:mobile_app/utils/co2_voc_color.dart';
import 'package:mobile_app/widgets/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.apiService});
  final ApiService apiService;
  
  @override
  State<HomeScreen> createState() => _MyHomeScreen();
}

class _MyHomeScreen extends State<HomeScreen> {
  late SensorService sensorService;
  Map<String, dynamic>? sensorData;
  Map<String, dynamic>? enviromentalData;
  Map<String, dynamic>? pollenData;
  late Timer sensorUpdateTimer;
  late EnviromentalService enviromentalService;
  late PollenService pollenService;
  double latitude = 32.32;
  double longitude = 35.32;
  List<Map<String, dynamic>> plantAllergens = [];
  List<Map<String, dynamic>> pollenAllergens = [];
  late LocationService locationService;
  late SaveAllergenService saveAllergenService;
  late ProfileService profileService;
  Map<String, dynamic>? locationData;
  String? fileName;
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    sensorService = SensorService(widget.apiService);
    _loadSensor();
    sensorUpdateTimer = Timer.periodic(Duration(minutes: 10), (Timer timer) {
      _loadSensor();
    });
    locationService = LocationService(widget.apiService);
    _loadLocationData();
    enviromentalService = EnviromentalService(widget.apiService);
    pollenService = PollenService(widget.apiService);
    locationService = LocationService(widget.apiService);
    saveAllergenService = SaveAllergenService(widget.apiService);
    _loadEnviromentalData();
    _fetchAndPostAirQualityData();
   
    profileService = ProfileService(widget.apiService);
    _initializeProfileData();
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

  Future<void> _loadLocationData() async {
    try{
      final Map<String, dynamic> data = await locationService.getUserLocation();
      final double newLatitude = data['location']['latitude'];
      final double newLongitude = data['location']['longitude'];
      setState(() {
        latitude = newLatitude;
        longitude = newLongitude;
        locationData = data;
      });
      print(locationData);
      _fetchAndPostAirQualityData();
      _loadEnviromentalData();
    }catch(error){
      print('error loading location $error');
    }
  }

  Future<void> _loadEnviromentalData() async {
    try {
      final Map<String, dynamic> data = await enviromentalService.getEnviromental();
       setState(() {
        enviromentalData = data;
        plantAllergens = getPlantType(enviromentalData);
        pollenAllergens = getPollenType(enviromentalData);
        
        try {
           saveAllergenService.saveAllergenData(plantAllergens);
           saveAllergenService.saveAllergenData(pollenAllergens);
        } catch (error) {
          print('Error saving allergen data: $error');
        }
      });
    } catch (error) {
      print('Error loading health data: $error');
    }
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
        sensorData = data;
      });
     print(sensorData);
    } catch (error) {
      print('Error loading health data: $error');
    }
  }

    Future<void> _fetchAndPostAirQualityData() async {
      try {
        final pollen = pollenService.fetchAndPostPollen(latitude, longitude);
        await Future.delayed(Duration(seconds: 1));
        final airQuality = enviromentalService.fetchAirQualityDataAndPost(latitude, longitude);
        
        await Future.wait([airQuality, pollen]);
      } catch (error) {
        print('Error fetching and posting air quality data: $error');
      }
    }

  @override
  Widget build(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    int co2Value = sensorData?['lastSensorData']?['co2'] ?? 0;
    int vocValue = sensorData?['lastSensorData']?['voc'] ?? 0;
    String dominantPollutant = '${enviromentalData?['environmentalData']?['dominantPollutant'] ?? ''}';
    dominantPollutant = dominantPollutant.toUpperCase();
    String aqiCategory = '${enviromentalData?['environmentalData']?['aqiCategory'] ?? ''}';
    String aqiCondition = aqiCategory.split(' ').first;
    
    Color statusColor = getStatusColor(
      co2Value > vocValue ? co2Value : vocValue,
      co2Value > vocValue ? 'co2' : 'voc',
    );

    String statusText = getStatusText(
      co2Value > vocValue ? co2Value : vocValue,
      co2Value > vocValue ? 'co2' : 'voc',
    );

    final Map<String, Color> colorMapping = {
    'primaryColor': primaryColor,
    'secondaryColor': secondaryColor,
    'red': Colors.red
  };

    List<Map<String, dynamic>> plantAllergens = getPlantType(enviromentalData);
    List<Map<String, dynamic>> pollenAllergens = getPollenType(enviromentalData);
    
    Color getColorFromName(String colorName) {
    return colorMapping[colorName] ?? Colors.black;
    }
   
    String gasName(String dominantPollutant) {
      switch (dominantPollutant.toLowerCase()) {
        case 'o3':
          return 'Ozone';
        case 'co':
          return 'Carbon monoxide';
        case 'pm10':
          return 'Inhalable particulate (<10µm)';
        case 'pm25':
          return 'Fine particulate (<2.5µm)';
        case 'so2':
          return 'Sulfur dioxide';
        case 'no2':
          return 'Nitrogen dioxide';
        default:
          return 'Unknown Gas'; 
      }
    }
    
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: Colors.black12,
            ),
          )
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              height: (screenHeight - appBarHeight - bottomNavBarHeight) * 0.355,
              color: const Color.fromRGBO(255, 252, 252, 1),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    color: const Color.fromRGBO(255, 252, 252, 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/home/profile/edit');
                          },
                          child: ClipOval(
                            child: Container(
                              width: 90,
                              height: 90,
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
                        // const SizedBox(width: 10), 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                            'Hello ${profileData?['user']?['firstName']}, How are you doing today?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(74, 74, 74, 1),
                              )
                            ),
                            const SizedBox(width: 2,),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, '/medcat');
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
                  // const SizedBox(height: 15,),
                  // Container(
                  //   width: 360,
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                  //     borderRadius: BorderRadius.circular(15)
                  //   ),
                  // ),
                  // const SizedBox(height: 10,),
                  // Container(
                  //   width: 360,
                  //   height: 50,
                  //  decoration: BoxDecoration(
                  //   border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                  //   borderRadius: BorderRadius.circular(15)
                  // ),
                  // )
                ],
              ),
            ),

            Container(
              height: (screenHeight - appBarHeight - bottomNavBarHeight) * 0.57,
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
                            padding: const EdgeInsets.all(15),
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
                              const SizedBox(height: 5,),
                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      SvgPicture.asset('lib/assets/icons/carbon-dioxide.svg', height: 50, width: 50,),
                                      const SizedBox(height: 10,),
                                      Text(
                                      '${sensorData?['lastSensorData']?['co2'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: getStatusColor(
                                          sensorData?['lastSensorData']?['co2'] ?? 0,
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
                                        padding: const EdgeInsets.all(7),
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
                                      const SizedBox(height: 14),
                                      Text(
                                        '${sensorData?['lastSensorData']?['voc'] ?? ''}', 
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: getStatusColor(
                                          sensorData?['lastSensorData']?['voc'] ?? 0,
                                          'voc',
                                          )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
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
                                  style: const TextStyle(
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
                         child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset('lib/assets/icons/leaf2.svg', height: 23, width: 23,),
                                            const SizedBox(width: 5,),
                                            Text(
                                              '${plantAllergens.isNotEmpty && (plantAllergens.length!=null && plantAllergens.isNotEmpty) ? plantAllergens[0]['displayName'] ?? '' : ''}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: getColorFromName(plantAllergens.isNotEmpty ? plantAllergens[0]['color'] : 'black'),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                          Row(
                                          children: [
                                            SvgPicture.asset('lib/assets/icons/olive.svg', height: 23, width: 25,),
                                            const SizedBox(width: 5,),
                                            Text(
                                             '${plantAllergens.isNotEmpty && (plantAllergens.length!=null && plantAllergens.isNotEmpty) ? plantAllergens[1]['displayName'] ?? '' : ''}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: getColorFromName(plantAllergens.isNotEmpty ? plantAllergens[0]['color'] : 'black'),
                                              ),
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                 Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: myGray.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Plant', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: myGray.withOpacity(0.9)),),
                                        Text('Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: myGray.withOpacity(0.9)),),
                                    ],
                                  ),
                                 ))
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset('lib/assets/icons/leaf1.svg', height: 23, width: 23,),
                                            const SizedBox(width: 5,),
                                            Text(
                                              '${plantAllergens.isNotEmpty && (pollenAllergens != null && pollenAllergens.isNotEmpty) ? (pollenAllergens.length > 0 ? pollenAllergens[0]['displayName'] ?? '' : '') : ''}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: getColorFromName(plantAllergens.isNotEmpty ? pollenAllergens[0]['color'] : 'black'),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                          Row(
                                          children: [
                                            SvgPicture.asset('lib/assets/icons/tree1.svg', height: 23, width: 25,),
                                            const SizedBox(width: 5,),
                                            Text(
                                               '${plantAllergens.isNotEmpty && (pollenAllergens != null && pollenAllergens.isNotEmpty) ? (pollenAllergens.length > 1 ? pollenAllergens[1]['displayName'] ?? '' : '') : ''}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: getColorFromName(plantAllergens.isNotEmpty ? pollenAllergens[0]['color'] : 'black'),
                                              ),
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                 Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: myGray.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Pollen', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: myGray.withOpacity(0.9)),),
                                        Text('Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: myGray.withOpacity(0.9)),),
                                    ],
                                  ),
                                 ))
                                ],
                              ),
                            ],
                           ),
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
                          height: 190,
                          decoration: BoxDecoration(
                            border: Border.all(color: myGray.withOpacity(0.3), width: 1),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                            children: [
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                    Text(
                                      'AQI',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: myGray.withOpacity(0.95)
                                      ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                      '${enviromentalData?['environmentalData']?['aqi'] ?? ''} ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: getStatusColor(enviromentalData?['environmentalData']?['aqi'] ?? 0, 'aqi'),
                                      ),
                                      ),
                                      const SizedBox(width: 10,),
                                      aqiCondition == 'Good'
                                      ? SvgPicture.asset(
                                          'lib/assets/icons/smiling.svg',
                                          height: 18,
                                          width: 18,
                                        )
                                      : SvgPicture.asset(
                                          'lib/assets/icons/sad.svg',
                                          height: 18,
                                          width: 18,
                                        ),
                                  ],),
                                  const SizedBox(width: 10,),
                                  const Center(
                                    child: Icon(
                                    Icons.air,
                                    size: 30,
                                    color: myGray,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      child: Padding( 
                                        padding: const EdgeInsets.all(7),
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
                                            'PM25',
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
                                      const SizedBox(height: 10),
                                      Text(
                                        '${enviromentalData?['environmentalData']?['pm25'] ?? ''}', 
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: getColorEnv(enviromentalData?['environmentalData']?['pm25'] ?? 0, 'so2')
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
                                      const SizedBox(height: 17,),
                                      Text(
                                      '${enviromentalData?['environmentalData']?['no2Level'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: getColorEnv(enviromentalData?['environmentalData']?['no2Level'] ?? 0, 'no2')
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
                                        '${enviromentalData?['environmentalData']?['pm10'] ?? ''}', 
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: getColorEnv(enviromentalData?['environmentalData']?['pm10'] ?? 0, 'pm10')
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 14,),
                             Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Dominant Pollutant',
                                  style: TextStyle(
                                    color: myGray,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  gasName(dominantPollutant), 
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor.withOpacity(0.7),
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
        selectedIndex: 0, 
     ),
    );
  }
   void _showNotificationOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200, 
          child: Column(
            children: [
           
              ListTile(
                title: const Text('Notification 1'),
                onTap: () {
                 
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Notification 2'),
                onTap: () {
                 
                  Navigator.pop(context);
                },
              ),
             
            ],
          ),
        );
      },
    );
  }
}
