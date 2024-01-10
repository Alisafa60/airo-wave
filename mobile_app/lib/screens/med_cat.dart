import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MedCatScreen extends StatelessWidget{
  const MedCatScreen ({super.key});

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
                  color: const Color.fromRGBO(74, 74, 74, 0.2),
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
                          backgroundColor: const Color.fromRGBO(255, 113, 19, 0.683),
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
            )
          ]
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/home-filled.svg',
            height: 35, width: 35,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/MedCat.svg',
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


}