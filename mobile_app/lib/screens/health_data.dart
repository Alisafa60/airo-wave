import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/constants.dart';

class ShowHealthScreen  extends StatelessWidget{
  const ShowHealthScreen({super.key});

  @override
  Widget build(BuildContext context){

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:   
        AppBar(
        backgroundColor:const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
          "Health",
          selectionColor: Color.fromRGBO(74, 74, 74, 1),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
        ),),
        centerTitle: true,
        leading: IconButton (
          padding: EdgeInsets.all(15),
          icon: Icon(Icons.arrow_back_ios, color: primaryColor,),
          onPressed: () {
          },),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: Colors.black12,
            ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              height: 100,
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
                    ),
                  ),
                ]
              )
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(74, 74, 74, 0.2),
                      borderRadius: BorderRadius.circular(15), 
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(74, 74, 74, 0.2),
                      borderRadius: BorderRadius.circular(15), 
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Color.fromRGBO(74, 74, 74, 0.2),
                borderRadius: BorderRadius.circular(15), 
              ),
            ),
            SizedBox(height: 10,),
             Container(
              height: 120,
              decoration: BoxDecoration(
                color: Color.fromRGBO(74, 74, 74, 0.2),
                borderRadius: BorderRadius.circular(15), 
              ),
            ),
            SizedBox(height: 10,),
             Container(
              height: 120,
              decoration: BoxDecoration(
                color: Color.fromRGBO(74, 74, 74, 0.2),
                borderRadius: BorderRadius.circular(15), 
              ),
            ),
          ],
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
        ]),
    );
  }
}