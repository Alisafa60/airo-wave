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
                    Container(
                      height: 30, 
                      width: 70, 
                      decoration: BoxDecoration(
                        color: myGray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('Routes', style: TextStyle(color: myGray, fontSize: 12),),
                      ),
                    ),
                    Container(
                      height: 30, 
                      width: 70, 
                      decoration: BoxDecoration(
                        color: myGray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('Env. Data', style: TextStyle(color: myGray, fontSize: 12)),
                      ),
                    ),
                   Container(
                      height: 30, 
                      width: 70, 
                      decoration: BoxDecoration(
                        color: myGray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('HR', style: TextStyle(color: myGray, fontSize: 12)),
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