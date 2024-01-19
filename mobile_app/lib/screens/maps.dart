import 'dart:convert';
import 'dart:typed_data';
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
  TileOverlay? _heatmapTileOverlay;
  late GoogleMapController _googleMapController;
  int _currentPageIndex = 0;
  Image? heatmapTile;
  Uint8List? _imageBytes;
  final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  Future<void> fetchAndDisplayHeatmapTile(int zoom, int x, int y, String mapType) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    final apiUrl = "https://airquality.googleapis.com/v1/mapTypes/$mapType/heatmapTiles/$zoom/$x/$y?key=$apiKey";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        _heatmapTileOverlay = _buildTileOverlay(imageBytes);
        _addHeatmapTileOverlay(imageBytes);

        setState(() {});

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      } else {
        print('Failed to fetch heatmap tile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching heatmap tile: $error');
    }
  }

  TileOverlay _buildTileOverlay(Uint8List imageBytes) {
    final customTileProvider = CustomTileProvider(imageBytes);

    return TileOverlay(
      tileOverlayId: const TileOverlayId("heatmapTile"),
      tileProvider: customTileProvider,
      fadeIn: true,
      transparency: 0.0,
      zIndex: 0,
      visible: true,
      tileSize: 256,
    );
  }

  void _addHeatmapTileOverlay(Uint8List imageBytes) {
  final TileOverlay heatmapOverlay = TileOverlay(
    tileOverlayId: TileOverlayId('your_unique_tile_overlay_id'),
    tileProvider: CustomTileProvider(imageBytes),
    fadeIn: true,
    transparency: 0.0,
    zIndex: 0,
    visible: true,
    tileSize: 256,
  );

  _googleMapController._
}

  @override
   void initState() {
    super.initState();
    fetchAndDisplayHeatmapTile(12, 0, 1, 'US_AQI');
  }
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
              target: LatLng(40.7128, -74.0060),
              zoom: 4.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
            },
            markers: {
              Marker(
                markerId: MarkerId('markerId'),
                position: LatLng(40.7128, -74.0060),
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
class CustomTileProvider extends TileProvider {
  final Uint8List imageBytes;

  CustomTileProvider(this.imageBytes);

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    return Tile(x, y, imageBytes);
  }
}