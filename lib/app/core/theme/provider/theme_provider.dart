import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeProvider = ChangeNotifierProvider((ref) => ThemeNotifier());

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get light => _themeMode == ThemeMode.light;
  bool get dark => _themeMode == ThemeMode.dark;
  bool get system => _themeMode == ThemeMode.system;

  ThemeNotifier();

  void setDark() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void setLight() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setSystem() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}
