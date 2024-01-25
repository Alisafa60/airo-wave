
import 'dart:math' show cos, log, tan;
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mobile_app/widgets/bottom_bar.dart';
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
  bool _showAllergyTile = false;
  GoogleMapController? _mapController;
  Location _location = Location();
  LocationData? _currentLocation;

  Set<TileOverlay> tileOverlaysSet = Set<TileOverlay>();

  Future<Map<String, dynamic>?> fetchHeatmapTile(int zoom, double latitude, double longitude, String mapType) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    final x = calculateX(longitude, zoom);
    final y = calculateY(latitude, zoom);

    final apiUrl = "https://airquality.googleapis.com/v1/mapTypes/$mapType/heatmapTiles/$zoom/$x/$y?key=$apiKey";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return {'imageBytes': response.bodyBytes, 'x': x, 'y': y};
      } else {
        print('Failed to fetch heatmap tile. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching heatmap tile: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchAllergyTile(int zoom, double latitude, double longitude, String mapType) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    final x = calculateX(longitude, zoom);
    final y = calculateY(latitude, zoom);

    final apiUrl = "https://pollen.googleapis.com/v1/mapTypes/$mapType/heatmapTiles/$zoom/$x/$y?key=$apiKey";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return {'imageBytes': response.bodyBytes, 'x': x, 'y': y};
      } else {
        print('Failed to fetch allergy tile. Status code: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error fetching allergy tile: $error');
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

  Future<void> updateTileOverlays() async {
    tileOverlaysSet.clear();

    if (_currentLocation != null) {
      double? latitude = _currentLocation!.latitude;
      double? longitude = _currentLocation!.longitude;
      if (latitude!=0 && longitude!=0) {
        if (_showHeatmap) {
          final heatmapData = await fetchHeatmapTile(4, latitude!, longitude!, 'GBR_DEFRA');
          if (heatmapData != null) {
            final Uint8List? heatmapImageBytes = heatmapData['imageBytes'];
            final int heatmapX = heatmapData['x'];
            final int heatmapY = heatmapData['y'];
            final CustomTileProvider heatmapCustomTileProvider = CustomTileProvider(heatmapImageBytes!, heatmapX, heatmapY, 2);

            tileOverlaysSet.add(TileOverlay(
              tileOverlayId: TileOverlayId("heatmapTile"),
              tileProvider: heatmapCustomTileProvider,
            ));
          }
        }

        if (_showAllergyTile) {
          final allergyData = await fetchAllergyTile(4, latitude!, longitude!, 'TREE_UPI');
          if (allergyData != null) {
            final Uint8List? allergyImageBytes = allergyData['imageBytes'];
            final int allergyX = allergyData['x'];
            final int allergyY = allergyData['y'];
            final CustomTileProvider allergyCustomTileProvider = CustomTileProvider(allergyImageBytes!, allergyX, allergyY, 2);

            tileOverlaysSet.add(TileOverlay(
              tileOverlayId: TileOverlayId("allergyTile"),
              tileProvider: allergyCustomTileProvider,
            ));
          }
        }
      }
    }
  }

  

   Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
      });
    });
  }

   @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    // _requestLocationPermission();
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
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _mapController = controller;
              });
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(_currentLocation?.latitude ?? 48.8566, _currentLocation?.longitude ?? 2.3522),
              zoom: 4,
            ),
            markers: {
              Marker(
                markerId: MarkerId('markerId'),
                position: LatLng(_currentLocation?.latitude ?? 48.8566, _currentLocation?.longitude ?? 2.3522),
                infoWindow: InfoWindow(title: 'Marker Title'),
              ),
            },
            tileOverlays: tileOverlaysSet,
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
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, right: 10),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              _showHeatmap = !_showHeatmap;
                            });
                            updateTileOverlays(); // Update tile overlays based on conditions
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, right: 10),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              _showAllergyTile = !_showAllergyTile;
                            });
                            updateTileOverlays(); 
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _showAllergyTile ? Colors.green : Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'Allergy',
                                style: TextStyle(
                                  color: _showAllergyTile ? Colors.white : Colors.green,
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
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 2,
      ),
    );
  }
}

class CustomTileProvider extends TileProvider {
  Uint8List imageBytes;
  int x;
  int y;
  int zoom;

  CustomTileProvider(this.imageBytes, this.x, this.y, this.zoom);

  void updateImageData(Uint8List newImageBytes, int newX, int newY) {
    imageBytes = newImageBytes;
    x = newX;
    y = newY;
  }

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    if (x != this.x || y != this.y) {
      print('Mismatched x or y values. Expected: x=${this.x}, y=${this.y}. Actual: x=$x, y=$y. Skipping fetch.');
      return Tile(this.x, this.y, Uint8List(0));
    }

    print('getTile called with x: $x, y: $y, zoom: $zoom, calculated X: $this.x, calculated Y: $this.y, calculated Zoom: $this.zoom');

    return Tile(this.x, this.y, imageBytes);
  }
}
