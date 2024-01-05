import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 251, 245, 1),
        title: const Text("Home",
          selectionColor: Color.fromRGBO(74, 74, 74, 1),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
        ),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.add_circle_outline, color:  Color.fromRGBO(255, 115, 29, 1), size: 40), 
          onPressed: () {  

          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.circle_notifications_outlined, color:  Color.fromRGBO(255, 115, 29, 1), size: 40), 
            onPressed: () { 

             },
            )
        ],
      )
    );
  }
}