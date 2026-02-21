import 'package:flutter/material.dart';
import 'package:tayssir/features/home/presentation/widgets/course_widget.dart';

class ToolModel {
  final String name;
  final String description;
  final String pathName;
  // final String iconPath;
  final Color startColor;
  final Color endColor;
  final bool isLocked;
  final ToolImage toolImage;
  final bool isStartBottomColor;

  ToolModel({
    required this.name,
    required this.description,
    required this.pathName,
    required this.startColor,
    required this.endColor,
    // required this.iconPath,
    required this.isLocked,
    required this.toolImage,
    this.isStartBottomColor = true,
  });
}
