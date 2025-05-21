import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/dark_mode.dart';

import 'package:habit_tracker/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode; // initially, light mode

  ThemeData get themeData => _themeData; // get current theme

// // boolean ofr theme, theme is dark mode
//   bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    // set theme
    _themeData = themeData;
    notifyListeners();
  }

// toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
