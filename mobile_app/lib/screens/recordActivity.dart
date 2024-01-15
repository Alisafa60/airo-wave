import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/constants.dart';

class RecordActivityScreen extends StatelessWidget{
  const RecordActivityScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          backgroundColor:const Color.fromRGBO(255, 252, 252, 1),
          title: const Text(
            "Record",
            selectionColor: myGray,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
          ),),
          centerTitle: true,
          leading: IconButton (
            icon: const Icon(Icons.close, size: 30,),
            onPressed: () {
            },
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: myGray.withOpacity(0.2), width: 2)),
                      ),
                      child: Center(
                        child: SvgPicture.asset('lib/assets/icons/environment.svg', height: 40, width: 40,),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: myGray.withOpacity(0.4), width: 2)),
                      ),
                      child: const Center(
                        child: Icon(Icons.run_circle_outlined, color: myGray, size: 30,),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: myGray.withOpacity(0.4), width: 2)),
                      ),
                      child: const Center(
                        child: Icon(Icons.monitor_heart, color: myGray, size: 30,),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      child: const Center(
                        child: Icon(Icons.route_outlined, color: myGray, size: 30,),
                      ),
                    ),
                  ),
                ],
              ),

                SizedBox(height: 20), 
                Container(
                  height: 70,
                  width: 100,
                  child: Image.asset('lib/assets/icons/start-button.png', height: 70,),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}