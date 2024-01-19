
import 'dart:math' show cos, log, tan;
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
  int _currentPageIndex = 0;
  bool _showHeatmap = false; 
  Future<Uint8List?> fetchHeatmapTile(int zoom, double latitude, double longitude, String mapType) async {
  final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  final x = calculateX(longitude, zoom);
  final y = calculateY(latitude, zoom);

  final apiUrl = "https://airquality.googleapis.com/v1/mapTypes/$mapType/heatmapTiles/$zoom/$x/$y?key=$apiKey";
  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return response.bodyBytes;
      
    } else {
      print('Failed to fetch heatmap tile. Status code: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Error fetching heatmap tile: $error');
    return null;
  }
}

  int calculateX(double longitude, int zoom) {
    final x = ((longitude + 180) / 360 * (1 << zoom)).floor();
    print('calculated X: $x');
    return x;
  }

  int calculateY(double latitude, int zoom) {
    double latRad = latitude * (3.141592653589793 / 180);
    final y = ((1 - log(tan(latRad) + 1 / cos(latRad)) / 3.141592653589793) / 2 * (1 << zoom)).floor();
     print('Calculated Y: $y');
     return y;
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
      body: FutureBuilder(
        future: fetchHeatmapTile(8, 40.7128, -74.0060, 'US_AQI'),
        builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            final Uint8List? imageBytes = snapshot.data;
            final CustomTileProvider customTileProvider = CustomTileProvider(imageBytes!, -74.0060, 40.7128, 2);

            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(40.7128, -74.0060),
                    zoom: 8,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('markerId'),
                      position: LatLng(40.7128, -74.0060),
                      infoWindow: InfoWindow(title: 'Marker Title'),
                    ),
                  },
                 tileOverlays: {
                  if (_showHeatmap)
                    TileOverlay(
                      tileOverlayId: TileOverlayId("heatmapTile"),
                      tileProvider: customTileProvider,
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
                                filled: true,
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
                                  borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115, 29, 0.6)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.2)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16, right: 10),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _showHeatmap = !_showHeatmap; 
                                  });
                                  if (_showHeatmap) {
                                    final Uint8List? imageBytes = await fetchHeatmapTile(8, 40.7128, -74.0060, 'US_AQI');
                                    if (imageBytes != null) {
                                      customTileProvider.updateImageBytes(imageBytes);
                                    }
                                  }
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _showHeatmap ? Colors.blue : Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'AQI',
                                      style: TextStyle(
                                        color: _showHeatmap ? Colors.white : Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
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
  Uint8List imageBytes;
  double longitude;
  double latitude;
  int zoom;

  CustomTileProvider(this.imageBytes, this.longitude, this.latitude, this.zoom) {
    print('CustomTileProvider created with imageBytes length: ${imageBytes.length}');
  }

  void updateImageBytes(Uint8List newImageBytes) {
    imageBytes = newImageBytes;
  }


  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    final calculatedX = calculateX(longitude, zoom!);
    final calculatedY = calculateY(latitude, zoom);
   
    if (x != calculatedX || y != calculatedY) {
      print('Mismatched x or y values. Expected: x=$calculatedX, y=$calculatedY. Actual: x=$x, y=$y. Skipping fetch.');
      return Tile(calculatedX, calculatedY, Uint8List(0)); 
    }

    print('getTile called with x: $x, y: $y, zoom: $zoom, longitude: $longitude, latitude: $latitude');
    print('Calculated X: $calculatedX, Calculated Y: $calculatedY');

    // Create the tile
    return Tile(calculatedX, calculatedY, imageBytes);
  }

  int calculateX(double longitude, int zoom) {
    return ((longitude + 180) / 360 * (1 << zoom)).floor();
  }

  int calculateY(double latitude, int zoom) {
    double latRad = latitude * (3.141592653589793 / 180);
    return ((1 - log(tan(latRad) + 1 / cos(latRad)) / 3.141592653589793) / 2 * (1 << zoom)).floor();
  }
}