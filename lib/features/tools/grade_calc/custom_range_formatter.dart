// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CustomRangeFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     if (newValue.text.isEmpty) {
//       return newValue;
//     }

//     try {
//       double value = double.parse(newValue.text);
//       if (value < 0 || value > 20) {
//         return oldValue;
//       }

//       if (value % 1 != 0 &&
//           value % 1 != 0.25 &&
//           value % 1 != 0.5 &&
//           value % 1 != 0.75
//           value 
          
//           ) {
//         return oldValue;
//       }

//       return newValue;
//     } catch (e) {
//       return oldValue;
//     }
//   }
// }
