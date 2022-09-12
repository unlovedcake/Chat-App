import 'package:flutter/material.dart';

class ThemeController with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  bool isDarkMode = false;

  get themeMode => _themeMode;

  get getDarkMode => isDarkMode;

  toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    isDarkMode = isDark;
    notifyListeners();
  }
}
