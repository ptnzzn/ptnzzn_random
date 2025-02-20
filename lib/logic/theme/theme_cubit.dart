import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ptnzzn_random/constants/app_theme.dart';

enum AppThemeMode { system, light, dark }

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppTheme.lightTheme);

  void changeTheme(AppThemeMode themeMode, BuildContext context) {
    switch (themeMode) {
      case AppThemeMode.system:
        final brightness = MediaQuery.of(context).platformBrightness;
        if (brightness == Brightness.dark) {
          emit(AppTheme.darkTheme);
        } else {
          emit(AppTheme.lightTheme);
        }
        break;
      case AppThemeMode.light:
        emit(AppTheme.lightTheme);
        break;
      case AppThemeMode.dark:
        emit(AppTheme.darkTheme);
        break;
    }
  }
}