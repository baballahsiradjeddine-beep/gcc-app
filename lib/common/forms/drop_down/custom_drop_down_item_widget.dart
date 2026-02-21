import 'package:flutter/material.dart';

class CustomDropDownItemWidget extends StatelessWidget {
  const CustomDropDownItemWidget({
    super.key,
    required this.itemName,
    required this.itemNumber,
  });

  final String itemName;
  final int itemNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("$itemName - "),
        Text(itemNumber.toString()),
      ],
    );
  }
}
