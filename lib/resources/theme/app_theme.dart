import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'SomarSans',
        scaffoldBackgroundColor: AppColors.scaffoldColor,
        brightness: Brightness.light,
        shadowColor: AppColors.shadowColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          surface: AppColors.surfaceWhite,
          onSurface: AppColors.textBlack,
          outline: AppColors.borderColor,
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 2, // Subtle elevation for light mode
          shadowColor: AppColors.shadowColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          color: AppColors.surfaceWhite,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textBlack),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark, // Android
            statusBarBrightness: Brightness.light, // iOS
          ),
        ),
        textTheme: _textTheme(Brightness.light),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'SomarSans',
        scaffoldBackgroundColor: AppColors.darkColor,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          surface: AppColors.secondaryDark,
          onSurface: Colors.white,
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          color: AppColors.secondaryDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light, // Android
            statusBarBrightness: Brightness.dark, // iOS
          ),
        ),
        textTheme: _textTheme(Brightness.dark),
      );

  static TextTheme _textTheme(Brightness brightness) {
    // Header text is always bold/black to standout
    final headerColor = brightness == Brightness.light ? AppColors.textBlack : Colors.white;
    // Body text is slightly softer for readability
    final bodyColor = brightness == Brightness.light ? AppColors.textBody : Colors.white.withOpacity(0.9);

    return TextTheme(
      displayLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w900, color: headerColor, fontFamily: 'SomarSans', letterSpacing: -0.5),
      displayMedium: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w900, color: headerColor, fontFamily: 'SomarSans', letterSpacing: -0.5),
      displaySmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: headerColor, fontFamily: 'SomarSans'),
      headlineMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: headerColor, fontFamily: 'SomarSans'),
      titleLarge: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: headerColor, fontFamily: 'SomarSans'),
      titleMedium: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: headerColor, fontFamily: 'SomarSans'),
      bodyLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: bodyColor, fontFamily: 'SomarSans'),
      bodyMedium: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal, color: bodyColor, fontFamily: 'SomarSans'),
      labelSmall: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: bodyColor, fontFamily: 'SomarSans'),
    );
  }
}
