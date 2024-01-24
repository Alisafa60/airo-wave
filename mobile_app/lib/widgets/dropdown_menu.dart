import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';

class GenderDropdownForm extends StatefulWidget {
  final String? currentValue;
  final ValueChanged<String?> onChanged;

  const GenderDropdownForm({super.key, required this.currentValue, required this.onChanged});

  @override
  State<GenderDropdownForm> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<GenderDropdownForm> {
  String? currentValue;

  @override
  void initState() {
    currentValue = widget.currentValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(currentValue);
    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: myGray.withOpacity(0.4)),
        ),
      ),
      child: InkWell(
        onTap: () {
          _showGenderPicker(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentValue ?? 'Select gender',
              style: TextStyle(color: myGray.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Icon(Icons.arrow_drop_down, color: myGray.withOpacity(0.7),),
          ],
        ),
      ),
    );
  }

  void _showGenderPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: ListView(
            shrinkWrap: true, 
            children: ['Male', 'Female', 'Other'].map((String gender) {
              return ListTile(
                title: Text(gender),
                onTap: () {
                  setState(() {
                    currentValue = gender;
                  });
                  widget.onChanged(gender);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// class GenderDropdownFormField extends StatelessWidget {
//   final String? currentValue;
//   final ValueChanged<String?> onChanged;

//    GenderDropdownFormField({
//     super.key,
//     required this.currentValue,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     print(currentValue);
//     return Container(
//       height: 40,
//       width: double.infinity,
//       padding: const EdgeInsets.all(10),
//       child: 
//           DropdownButtonFormField<String>(
//             style: TextStyle(color: Colors.black, fontSize: 18),
//             selectedItemBuilder: (context) => [Text(currentValue!=null? currentValue! : '')],
//             decoration: InputDecoration(
//               hintText: 'Select gender',
//               hintStyle: TextStyle(
//                 color: myGray.withOpacity(0.4),
//               ),
//               border: InputBorder.none,
//               focusedBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(width: 2, color: primaryColor.withOpacity(0.6)),
//               ),
//               enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(width: 2, color: myGray.withOpacity(0.4)),
//               ),
//             ),
//             value: currentValue,
//             items: ['Male', 'Female', 'Other'].map((String gender) {
//               return DropdownMenuItem<String>(
//                 value: gender,
//                 child: Text(gender),
//               );
//             }).toList(),
//             onChanged: onChanged
//           ),
        
      
//     );
//   }
