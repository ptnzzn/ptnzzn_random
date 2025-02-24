import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ptnzzn_random/constants/app_theme.dart';

enum AppThemeMode { system, light, dark }

class ThemeCubit extends Cubit<ThemeData> {
  AppThemeMode _currentThemeMode = AppThemeMode.system;

  ThemeCubit() : super(AppTheme.lightTheme);

  void changeTheme(AppThemeMode themeMode, BuildContext context) {
    _currentThemeMode = themeMode;
    _applyTheme();
  }

  void _applyTheme() {
    switch (_currentThemeMode) {
      case AppThemeMode.system:
        final brightness = WidgetsBinding.instance.window.platformBrightness;
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

  void updateSystemTheme() {
    if (_currentThemeMode == AppThemeMode.system) {
      _applyTheme();
    }
  }

  AppThemeMode get currentThemeMode => _currentThemeMode;
}