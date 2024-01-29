import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RecordActivityScreen extends StatefulWidget {
  const RecordActivityScreen({super.key});
  @override
  State<RecordActivityScreen> createState() => _RecordActivityScreenState();
}

class _RecordActivityScreenState extends State<RecordActivityScreen> {
  double startButtonScale = 1.0;

  late GoogleMapController mapController;
  late LocationData currentLocation;
  late LocationData lastLocation;
  Set<Marker> markers = {};
  List<LatLng> routePoints = [];
  double totalDistance = 0.0;
  double averageSpeed = 0.0;

  DateTime? startTime;
  DateTime? endTime;
  double elapsedTimeInSeconds = 0.0;
  Timer? timer;

  bool isTracking = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    initLocationService();
  }

  void initLocationService() async {
    Location location = Location();

    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
        if (isTracking && lastLocation != null) {
          double distance = calculateDistance(lastLocation, currentLocation);
          totalDistance += distance;
          updateSpeed(distance);
        }

        lastLocation = currentLocation;
        if (isTracking) {
          updateRoute();
          updateMarkers();
        }
      });
    });

    await location.requestPermission();
    currentLocation = await location.getLocation();
  }

  void updateRoute() {
    routePoints.add(LatLng(currentLocation.latitude!, currentLocation.longitude!));
  }

  void updateSpeed(double distance) {
    double speed = distance / 1; 
    averageSpeed = speed * 3600; 
  }

  double calculateDistance(LocationData from, LocationData to) {
   
    const double radius = 6371.0; 
    double lat1 = from.latitude! * pi / 180.0;
    double lon1 = from.longitude! * pi / 180.0;
    double lat2 = to.latitude! * pi / 180.0;
    double lon2 = to.longitude! * pi / 180.0;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radius * c; 
  }

  void updateMarkers() {
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId('currentLocation'),
        position: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        infoWindow: InfoWindow(title: 'Current Location'),
      ),
    );
  }

  void stopActivity() {
    endTime = DateTime.now();
    timer?.cancel();
    isTracking = false;
  }

  void startActivity() {
    setState(() {
      startTime = DateTime.now();
      elapsedTimeInSeconds = 0.0;
      totalDistance = 0.0;
      routePoints.clear();
      markers.clear();
      isTracking = true;
    });
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
      if (isPaused) {
      } else {
       
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
          "Record",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30),
          onPressed: () {
           Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.black12,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
              zoom: 15.0,
            ),
            markers: markers,
            polylines: {
              Polyline(
                polylineId: PolylineId("route"),
                color: Colors.blue,
                points: routePoints,
              ),
            },
            myLocationEnabled: true,
          ),
          Align(
            
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'lib/assets/icons/environment.svg',
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.run_circle_outlined,
                                color: Colors.grey.withOpacity(0.6), size: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.monitor_heart,
                                color: Colors.grey.withOpacity(0.6), size: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: Center(
                            child: Icon(Icons.route_outlined,
                                color: Colors.grey.withOpacity(0.6), size: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        startButtonScale = 0.9;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        startButtonScale = 1.0;
                      });

                      if (isTracking) {
                        stopActivity();
                      } else {
                        startActivity();
                      }
                    },
                    child: Transform.scale(
                      scale: startButtonScale,
                      child: Container(
                        height: 70,
                        width: 70,
                        child: Image.asset(
                          isTracking
                              ? 'lib/assets/icons/stop-button.svg'
                              : 'lib/assets/icons/start-button.png',
                          height: 70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
