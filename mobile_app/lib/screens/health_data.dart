import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/constants.dart';

class ShowHealthScreen extends StatefulWidget {
  const ShowHealthScreen({Key? key}) : super(key: key);

  @override
  State<ShowHealthScreen> createState() => _ShowHealthScreenState();
}

class _ShowHealthScreenState extends State<ShowHealthScreen> {
  int selectedContainerIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
          "Health",
          selectionColor: Color.fromRGBO(74, 74, 74, 1),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          padding: EdgeInsets.all(15),
          icon: Icon(Icons.arrow_back_ios, color: myGray),
          onPressed: () {},
        ),
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
                    child: Stack(
                      children: [
                        ClipOval(
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
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.edit_note,
                                size: 25,
                                color: myGray.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
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
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedContainerIndex = 0;
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 110,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: myGray.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                            child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.bloodtype_outlined,
                                size: 25,
                                color: Colors.red.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.edit_note,
                                size: 25,
                                color: myGray.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedContainerIndex = 1;
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 110,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: myGray.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: SvgPicture.asset(
                                'lib/assets/icons/weight.svg',
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.edit_note,
                                size: 25,
                                color: myGray.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedContainerIndex = 2;
                });
              },
              child: Stack(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: myGray.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: 
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          'lib/assets/icons/leaf.svg',
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.edit_note,
                          size: 25,
                          color: myGray.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedContainerIndex = 3;
                });
              },
              child: Stack(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: myGray.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: 
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          'lib/assets/icons/lungs.svg',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.edit_note,
                          size: 25,
                          color: myGray.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedContainerIndex = 4;
                });
              },
              child: Stack(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: myGray.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: 
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          'lib/assets/icons/pill.svg',
                          height: 23,
                          width: 23,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.edit_note,
                          size: 25,
                          color: myGray.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ],
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
        ],
      ),
    );
  }
}
