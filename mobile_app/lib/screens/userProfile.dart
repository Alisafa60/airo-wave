import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey _containerKey = GlobalKey();
  bool _isMetric = true; 
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
            "Profile",
            selectionColor: Color.fromRGBO(74, 74, 74, 1),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
          ),),
          centerTitle: true,
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
            const SizedBox(height: 50,),
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              child: const TextField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintText: ' First name',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 0.4),
                  ),
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115 , 29, 0.6)), 
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.4)), 
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              child: const TextField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintText: ' Last name',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 0.4),
                  ),
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115 , 29, 0.6)), 
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.4)), 
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              child: const TextField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintText: ' Phone number',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 0.4),
                  ),
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115 , 29, 0.6)), 
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.4)), 
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select gender',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 0.4),
                  ),
                  border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115 , 29, 0.6)), 
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.4)), 
                  ),
                ),
                value: _selectedGender,
                items: ['Male', 'Female', 'Other'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender,),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              child: const TextField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintText: ' Address',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 0.4),
                  ),
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(255, 115 , 29, 0.6)), 
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color.fromRGBO(74, 74, 74, 0.4)), 
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ' Preferred Units',
                  style: TextStyle(
                    color: Color.fromRGBO(74, 74, 74, 1),
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _isMetric ? 'Metric' : 'Imperial',
                      style: TextStyle(
                        color: Color.fromRGBO(74, 74, 74, 0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      value: _isMetric,
                      onChanged: (value) {
                        setState(() {
                          _isMetric = value;
                        });
                      },
                      activeColor: Color.fromRGBO(255, 115, 29, 0.6),
                      inactiveThumbColor: Color.fromRGBO(95, 157, 247, 0.8),
                      activeTrackColor: Color.fromRGBO(255, 115, 29, 0.2),
                      inactiveTrackColor: Color.fromRGBO(95, 157, 247, 0.4),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30,),
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 115, 19, 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
               child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
               )
              ),
            ),
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
