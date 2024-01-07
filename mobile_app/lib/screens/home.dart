import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: const Size.fromHeight(50),
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
      body: Container(
        color: const Color.fromRGBO(255, 252, 252, 1),
        child: Column(
          children: [
            Container(
               height: 200,
              
            ),
            Container(
              height: 200,
              
            )
          ],
        ),
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