import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

enum AppThemeMode { system, light, dark }

class ThemeCubit extends Cubit<ThemeMode> {
  AppThemeMode _currentThemeMode = AppThemeMode.system;

  ThemeCubit() : super(ThemeMode.light);

  void changeTheme(AppThemeMode themeMode, BuildContext context) {
    _currentThemeMode = themeMode;
    _applyTheme();
  }

  void _applyTheme() {
    switch (_currentThemeMode) {
      case AppThemeMode.system:
        final brightness = PlatformDispatcher.instance.platformBrightness;
        if (brightness == Brightness.dark) {
          emit(ThemeMode.dark);
        } else {
          emit(ThemeMode.light);
        }
        break;
      case AppThemeMode.light:
        emit(ThemeMode.light);
        break;
      case AppThemeMode.dark:
        emit(ThemeMode.dark);
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