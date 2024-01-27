import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ActivityTracker extends StatefulWidget {
  const ActivityTracker({super.key});

  @override
  State<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends State<ActivityTracker> {
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

  void calculateAverageSpeed() {
    if (elapsedTimeInSeconds > 0) {
      averageSpeed = totalDistance / (elapsedTimeInSeconds / 3600);
    }
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
          onPressed: () { Navigator.pushReplacementNamed(context, '/home');},
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 120, 
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Total Distance: ${totalDistance.toStringAsFixed(2)} km'),
                  Text('Average Speed: ${averageSpeed.toStringAsFixed(2)} km/h'),
                  Text('Elapsed Time: ${formatElapsedTime(elapsedTimeInSeconds)}'),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isTracking) {
            stopActivity();
          } else {
            startActivity();
          }
        },
        child: Icon(isTracking ? Icons.stop : Icons.play_arrow),
      ),
      bottomNavigationBar: BottomAppBar(
        // child: Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Text('Total Distance: ${totalDistance.toStringAsFixed(2)} km'),
        //       Text('Average Speed: ${averageSpeed.toStringAsFixed(2)} km/h'),
        //       Text('Elapsed Time: ${formatElapsedTime(elapsedTimeInSeconds)}'),
        //       ElevatedButton(
        //         onPressed: togglePause,
        //         child: isPaused ? SvgPicture.asset('assets/resume.svg') : SvgPicture.asset('assets/pause.svg'),
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
                  
        //         },
        //         child: SvgPicture.asset('assets/your_custom_button.svg'),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  String formatElapsedTime(double seconds) {
    Duration duration = Duration(seconds: seconds.toInt());
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
