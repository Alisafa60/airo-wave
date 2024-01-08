import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double bottomNavBarHeight = kBottomNavigationBarHeight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:  PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBar(
          backgroundColor:const Color.fromRGBO(255, 252, 252, 1),
          title: const Text(
            "Home",
            selectionColor: Color.fromRGBO(74, 74, 74, 1),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
          ),),
          centerTitle: true,
          leading: IconButton (
            icon: SvgPicture.asset('lib/assets/icons/add-circle.svg', height: 40, width: 40,),
           onPressed: () {
           },),
          actions: [
            IconButton(
              icon: SvgPicture.asset('lib/assets/icons/notification-bell.svg', height: 40, width: 40,), 
              onPressed: () { 
              },
              )
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: (screenHeight - appBarHeight - bottomNavBarHeight) * 0.38,
            color: const Color.fromRGBO(255, 252, 252, 1),
            child: Column(
              children: [
                Container(
                  color: const Color.fromARGB(255, 211, 211, 211),
                  height: 1.5,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  color: const Color.fromRGBO(255, 252, 252, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      // const SizedBox(width: 10), 
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                           'Hello Ali, How are you doing today?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(74, 74, 74, 1),
                            )
                          ),
                          const SizedBox(width: 2,),
                          GestureDetector(
                            onTap: () {
                              //route to MedCat
                            },
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.arrow_forward,
                                  color: Color.fromRGBO(255, 115, 19, 1),
                                ),
                                Text(
                                  'MedCat',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: Color.fromRGBO(255, 115, 19, 1),
                                  )
                                )
                              ],
                            )
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: 330,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 115, 19, 0.2),
                    borderRadius: BorderRadius.circular(10), 
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: 330,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 115, 19, 0.2),
                    borderRadius: BorderRadius.circular(10), 
                  ),
                )
              ],
            ),
          ),

          Container(
            height: (screenHeight - appBarHeight - bottomNavBarHeight) * 0.55,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 179,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 115, 19, 0.2),
                          borderRadius: BorderRadius.circular(15), 
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Container(
                        height: 179,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 115, 19, 0.2),
                          borderRadius: BorderRadius.circular(15), 
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 179,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 115, 19, 0.2),
                          borderRadius: BorderRadius.circular(15), 
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Container(
                        height: 179,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 115, 19, 0.2),
                          borderRadius: BorderRadius.circular(15), 
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/home-filled.svg',
            height: 40, width: 40,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/MedCat.svg',
            height: 40, width: 40,),
            label: 'MedCat',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/map-location.svg',
            height: 40, width: 40,),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/activity-waves.svg',
            height: 40, width: 40,),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/community.svg',
            height: 40, width: 40,),
            label: 'Community',
          ),
        ]),

    );
  }
}