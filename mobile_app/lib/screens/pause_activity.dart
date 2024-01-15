import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/constants.dart';

class PauseActivityScreen extends StatefulWidget {
  const PauseActivityScreen({super.key});

  @override
  _PauseActivityScreenState createState() => _PauseActivityScreenState();
}

class _PauseActivityScreenState extends State<PauseActivityScreen> {
  double resumeButtonScale = 1.0;
  double finishButtonScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
          "Record",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30),
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
      body: Stack(
        
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: primaryColor,
            child: Center(
              child: Text('STOPPED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.25,
              child:Column(
                
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'lib/assets/icons/environment.svg',
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                          ),
                          child:  Center(
                            child: Icon(Icons.run_circle_outlined,
                                color: myGray.withOpacity(0.6), size: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.monitor_heart,
                                color: myGray.withOpacity(0.6), size: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: Center(
                            child: Icon(Icons.route_outlined,
                                color: myGray.withOpacity(0.6), size: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            resumeButtonScale = 0.9;
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            resumeButtonScale = 1.0;
                          });
                          // Handle the button press action here
                        },
                        child: Transform.scale(
                          scale: resumeButtonScale,
                          child: Container(
                            height: 70,
                            width: 70,
                            child: Image.asset(
                              'lib/assets/icons/resume-button.png',
                              height: 70,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            finishButtonScale = 0.9;
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            finishButtonScale = 1.0;
                          });
                          // Handle the button press action here
                        },
                        child: Transform.scale(
                          scale: finishButtonScale,
                          child: Container(
                            height: 70,
                            width: 70,
                            child: Image.asset(
                              'lib/assets/icons/finish-button.png',
                              height: 70,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30,),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 35,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(width: 30,)
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
