import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';

class GenderDropdownFormField extends StatefulWidget {
  final String? currentValue;
  final ValueChanged<String?> onChanged;
  const GenderDropdownFormField({super.key, required this.currentValue, required this.onChanged});
  
  @override
  State<GenderDropdownFormField> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<GenderDropdownFormField> {
  String? currentValue;
  @override
  void initState() {
    currentValue = widget.currentValue;
    // TODO: implement initState
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
    print(currentValue);
    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: 
          DropdownButtonFormField<String>(
            style: TextStyle(color: Colors.black, fontSize: 18),
            selectedItemBuilder: (context) => [Text(currentValue!=null? currentValue! : '')],
            decoration: InputDecoration(
              hintText: 'Select gender',
              hintStyle: TextStyle(
                color: myGray.withOpacity(0.4),
              ),
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 2, color: primaryColor.withOpacity(0.6)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 2, color: myGray.withOpacity(0.4)),
              ),
            ),
            value: currentValue,
            items: ['Male', 'Female', 'Other'].map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            
            onChanged: (value){
              setState(() {
                currentValue = value;
              });
              widget.onChanged(value);
            }
          ),
        
      
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
