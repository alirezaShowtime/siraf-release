import 'package:flutter/material.dart';
import 'package:siraf3/settings.dart';

class DarkThemeProvider with ChangeNotifier {
  Settings darkThemePreference = Settings();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkMode(value);
    notifyListeners();
  }
}