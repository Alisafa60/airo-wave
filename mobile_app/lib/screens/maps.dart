import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({Key? key}) : super(key: key);

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
      body: SlidingUpPanel(
        panelBuilder: (ScrollController scrollController) => Column(
          children: [
            Container(
              height: 30,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Image.asset('lib/assets/icons/rectangle-filled.png', height: 40, width: 40),
                  ],
                ),
              ),
            ),
            Container(
              height: 200, // Adjust the height as needed
              color: Colors.white, // Background color
              child: const Center(
                child: Text("This is the panel content"),
              ),
            ),
          ],
        ),
        // panel: Center(
        //   child: Text("This is the panel content"),
        // ),
        
        maxHeight: MediaQuery.of(context).size.height*0.7,
        minHeight: MediaQuery.of(context).size.height*0.15,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromARGB(44, 74, 74, 74), width: 1.5),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children : [
                      Padding(
                        padding: const EdgeInsets.only(right: 10), 
                        child: Icon(
                          Icons.search,
                          size: 30,
                          color: Color.fromRGBO(74, 74, 74, 0.7),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(74, 74, 74, 0.4),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ]
                  )
                ),
              ]),
            )
        ),
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
