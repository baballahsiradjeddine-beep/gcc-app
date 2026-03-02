import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core Brand Colors
  static const Color primaryColor = Color(0xFF00B4D8);
  static const Color primaryColorLight = Color(0xFFE0F2FE);
  static const Color secondaryColor = Color(0xFF0077B6);
  
  // Background / Surface Colors
  static const Color scaffoldColor = Color(0xFFF8FAFC); // brand.surface
  static const Color darkColor = Color(0xFF0B1120);     // brand.darkSurface
  static const Color secondaryDark = Color(0xFF0F172A); // dark.bg

  // Accent Colors
  static const Color pinkColor = Color(0xFFEC4899);
  static const Color pinkDark = Color(0xFFBE185D);
  static const Color purpleColor = Color(0xFFA855F7);
  static const Color purpleDark = Color(0xFF7E22CE);
  
  // States
  static const Color greenColor = Color(0xFF10B981); // From arena_screen success
  static const Color redColor = Color(0xFFF43F5E);   // From arena_screen failure

  // Legacy / Basic
  static const Color textBlack = Color(0xFF1E293B); // Slate-800
  static const Color textWhite = Color(0xFFF8FAFC);
  static const Color greyColor = Color(0xFF94A3B8); // Slate-400
  static const Color borderColor = Color(0xFFE2E8F0); // Slate-200
  static const Color disabledColor = Color(0xFFCBD5E1);
  static const Color disabledTextColor = Color(0xFF94A3B8);
  static const Color darkBlue = Color(0xFF1E293B);
  static const Color videoControls = Color(0xAA000000);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryColor, secondaryColor],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purpleColor, purpleDark],
  );

  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pinkColor, pinkDark],
  );
}
