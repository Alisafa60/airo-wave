import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

class UserProfileScreen extends StatelessWidget{
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(74, 74, 74, 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: IconButton(
              icon: const Icon(Icons.clear),
              color: const Color.fromRGBO(74, 74, 74, 1), 
              onPressed: () {  },
              iconSize: 30,
            )
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                color: const Color.fromRGBO(255, 252, 252, 1),
                child: GestureDetector(
                  onTap: () {
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(50, 150, 50, 50),
                      items: [
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'upload',
                          child: ListTile(
                            leading: Icon(Icons.upload),
                            title: Text('Upload'),
                          ),
                        ),
                      ],
                    );
                  },
                  child: ClipOval(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/assets/images/profile-picture.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}