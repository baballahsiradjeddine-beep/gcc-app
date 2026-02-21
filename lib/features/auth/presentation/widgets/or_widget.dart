import 'package:flutter/material.dart';

class OrWidget extends StatelessWidget {
  const OrWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: Color(0xffd5d5d5),
            height: 50,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'أو',
            style: TextStyle(
              color: Color(0xffd5d5d5),
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xffd5d5d5),
            height: 50,
          ),
        ),
      ],
    );
  }
}
