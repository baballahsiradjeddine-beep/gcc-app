import 'package:flutter/material.dart';

class NavItemModel {
  final int index;
  final String icon;
  final String label;
  final Widget page;

  NavItemModel(
      {required this.index,
      required this.icon,
      required this.label,
      required this.page});
}
