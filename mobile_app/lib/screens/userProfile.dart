import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

class UserProfileScreen extends StatelessWidget {
   UserProfileScreen({Key? key}) : super(key: key);

  final GlobalKey _containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              iconSize: 30,
            ),
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
                key: _containerKey,
                color: const Color.fromRGBO(255, 252, 252, 1),
                child: GestureDetector(
                  onTap: () {
                    showPopupMenu(context);
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

  void showPopupMenu(BuildContext context) {
    PopupMenu menu = PopupMenu(
      context: context,
      config: const MenuConfig(
        backgroundColor: Color.fromRGBO(220, 218, 218, 0.2),
      ),
      items: [
        MenuItem(
          title: 'Delete',
          textStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          image: const Icon(Icons.delete, color: Colors.red),
        ),
        MenuItem(
          title: 'Upload',
          textStyle: const TextStyle(color: Color.fromRGBO(95, 157, 247, 1), fontWeight: FontWeight.w600),
          image: const Icon(Icons.upload, color: Color.fromRGBO(95, 157, 247, 1)),
        ),
      ],
      onClickMenu: (MenuItemProvider item) {
        print('Menu item clicked: ${item.menuTitle}');
      },
    );
    menu.show(widgetKey: _containerKey);
  }
}
