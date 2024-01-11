import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

class MedCatScreen extends StatefulWidget {
  const MedCatScreen({Key? key}) : super(key: key);

  @override
  _MedCatScreenState createState() => _MedCatScreenState();
}

class _MedCatScreenState extends State<MedCatScreen> {
  @override
  Widget build(BuildContext context) {
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
                      // route for user profile
                    },
                    child: ClipOval(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'lib/assets/images/profile-picture.png'),
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
                    ),
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
                          backgroundColor:
                          const Color.fromRGBO(255, 117, 19, 0.683),
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
                        // Handle tap
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 117, 19, 1),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Show Analysis',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
          ],
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
          ],
      ),
    );
  }

}
