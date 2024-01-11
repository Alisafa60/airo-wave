import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MedCatScreen extends StatefulWidget{
  const MedCatScreen ({super.key});
   _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<MedCatScreen> {
  OverlayEntry? _overlayEntry;
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context){

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

      body: Padding(
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
                  const SizedBox(height: 5,),
                  const Text(
                    'Ali Safa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(74, 74, 74, 1),
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              ' How is your Allergy today?',
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
                  // color: const Color.fromRGBO(74, 74, 74, 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 1; i <= 5; i++)
                      GestureDetector(
                        onTap: () {
                          print('Pressed button $i');
                        },
                        child: CircleAvatar(
                          backgroundColor: const Color.fromRGBO(255, 117, 19, 0.683),
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
                        
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 117, 19, 1), // Adjust the color as needed
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Show Analysis',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white, // Adjust the text color as needed
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const TextField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintText: '...Ask MedCat',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 0.4),
                  ),
                  border: InputBorder.none,
                ),
                 style: TextStyle(
                  height: 1, // Adjust the value to vertically center the text within the TextField
                ),
              ),
            ),
            SizedBox(height: 10,),
              GestureDetector(
              onTap: () {
                if (!_isExpanded) {
                  _toggleOverlay();
                }
              },
              child: Container(
                height: 40,
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromRGBO(74, 74, 74, 0.5)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Tap to Expand',
                  style: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 1),
                  ),
                ),
              ),
            ),
          ]
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/home-filled-gray.svg',
            height: 35, width: 35,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/MedCat-orange.svg',
            height: 35, width: 35,),
            label: 'MedCat',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/map-location.svg',
            height: 35, width: 35,),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/activity-waves.svg',
            height: 35, width: 35,),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/community.svg',
            height: 35, width: 35,),
            label: 'Community',
          ),
        ]
      ),
    );
  }

void _toggleOverlay() {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black54,
            child: GestureDetector(
              onTap: () {
                _overlayEntry?.remove();
                _isExpanded = false;
              },
              child: Center(
                child: Container(
                  width: 400,
                  height: 1000,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Expanded Content Here',
                        style: TextStyle(
                          color: Color.fromRGBO(74, 74, 74, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(overlayEntry);
    _overlayEntry = overlayEntry;
    _isExpanded = true;
  }

}

