import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'SomarSans',
        scaffoldBackgroundColor: AppColors.scaffoldColor,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          surface: Colors.white,
          onSurface: AppColors.textBlack,
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          color: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textBlack),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          color: AppColors.secondaryDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: _textTheme(Brightness.dark),
      );

  static TextTheme _textTheme(Brightness brightness) {
    final textColor = brightness == Brightness.light ? AppColors.textBlack : Colors.white;
    return TextTheme(
      displayLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'SomarSans'),
      displayMedium: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'SomarSans'),
      displaySmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'SomarSans'),
      headlineMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'SomarSans'),
      titleLarge: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'SomarSans'),
      titleMedium: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: textColor, fontFamily: 'SomarSans'),
      bodyLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: textColor, fontFamily: 'SomarSans'),
      bodyMedium: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal, color: textColor, fontFamily: 'SomarSans'),
      labelSmall: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'SomarSans'),
    );
  }
}
