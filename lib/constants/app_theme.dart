import 'package:flutter/material.dart';
import 'package:ptnzzn_random/constants/app_color.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.blue,
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.blue,
        ),
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.blue,
      ),
    ),
    indicatorColor: AppColors.blue,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: AppColors.blue,
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.blue,
        ),
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.blue,
      ),
    ),
    indicatorColor: AppColors.blue,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  );
}