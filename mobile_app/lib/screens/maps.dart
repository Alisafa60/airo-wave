import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
          "Maps",
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
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(33.888630, 35.495480),
              zoom: 12.0,
            ),
            onMapCreated: (GoogleMapController controller) {},
            markers: {
              Marker(
                markerId: MarkerId('markerId'),
                position: LatLng(33.888630, 35.495480),
                infoWindow: InfoWindow(title: 'Marker Title'),
              ),
            },
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      width: double.infinity,
                      child: TextField(
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: ' Search',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(74, 74, 74, 0.4),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color.fromRGBO(74, 74, 74, 0.7),
                          ),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115 , 29, 0.6)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.2)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SlidingUpPanel(
                  panelBuilder: (ScrollController scrollController) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Image.asset(
                          'lib/assets/icons/rectangle-filled.png',
                          height: 30,
                          width: 40,
                        ),
                      ),
                      Container(
                        height: 30,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: _currentPageIndex == 0 ? Color.fromRGBO(255, 115, 19, 1) : Color.fromARGB(100, 0, 0, 0),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Routes',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(width: 70),
                              GestureDetector(
                                onTap: () {
                                  _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: _currentPageIndex == 1 ? Color.fromRGBO(255, 115, 19, 1) : const Color.fromARGB(100, 0, 0, 0),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Saved',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPageIndex = index;
                            });
                          },
                          children: [
                            Container(
                              color: Colors.white,
                              child: Center(
                                child: Text("Routes Page Content"),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: Center(
                                child: Text("Saved Page Content"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/icons/home-filled-gray.svg',
              height: 35,
              width: 35,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/icons/MedCat-orange.svg',
              height: 35,
              width: 35,
            ),
            label: 'MedCat',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/icons/map-location.svg',
              height: 35,
              width: 35,
            ),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/icons/activity-waves.svg',
              height: 35,
              width: 35,
            ),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/icons/community.svg',
              height: 35,
              width: 35,
            ),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}
