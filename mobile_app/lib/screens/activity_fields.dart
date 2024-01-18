import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/constants.dart';

class ActivityFieldsScreen  extends StatelessWidget{
  const ActivityFieldsScreen({super.key});

  @override
  Widget build(BuildContext context){

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar:   
      //   AppBar(
      //   backgroundColor:const Color.fromRGBO(255, 252, 252, 1),
      //   title: const Text(
      //     "Record",
      //     selectionColor: Color.fromRGBO(74, 74, 74, 1),
      //     style: TextStyle(
      //       fontSize: 20,
      //       fontWeight: FontWeight.w500,
      //   ),),
      //   centerTitle: true,
      //   leading: IconButton (
      //     padding: EdgeInsets.all(15),
      //     icon: Icon(Icons.arrow_back_ios, color: primaryColor,),
      //     onPressed: () {
      //     },),
      //     bottom: PreferredSize(
      //       preferredSize: const Size.fromHeight(1),
      //       child: Container(
      //         height: 1,
      //         color: Colors.black12,
      //       ),
      //   ),
      // ),
      body: Padding(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            
           
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Color.fromRGBO(74, 74, 74, 0.2),
                borderRadius: BorderRadius.circular(1), 
              ),
            ),
            SizedBox(height: 5,),
             Container(
              height: 140,
              decoration: BoxDecoration(
                color: Color.fromRGBO(74, 74, 74, 0.2),
                borderRadius: BorderRadius.circular(1), 
              ),
            ),
            SizedBox(height: 5,),
              Row(
              children: [
                Expanded(
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(74, 74, 74, 0.2),
                      borderRadius: BorderRadius.circular(5), 
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(74, 74, 74, 0.2),
                      borderRadius: BorderRadius.circular(5), 
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(74, 74, 74, 0.2),
                      borderRadius: BorderRadius.circular(5), 
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(74, 74, 74, 0.2),
                      borderRadius: BorderRadius.circular(5), 
                    ),
                  ),
                ),
               
              ],
            ),
          ],
        ),
      ),
    );
  }
}