import 'package:flutter/material.dart';

class ExerciseViewScaffold extends StatelessWidget {
  const ExerciseViewScaffold({super.key, required this.body});
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: body,
    );
  }
}
