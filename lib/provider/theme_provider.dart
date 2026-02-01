import 'package:flutter/material.dart';
import '../common/theme.dart';
import '../data/preferences/preferences_helper.dart';

class ThemeProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  ThemeProvider({required this.preferencesHelper}) {
    _getTheme();
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  ThemeMode get themeMode => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  ThemeData get themeData =>
      _isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme;

  void _getTheme() async {
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    preferencesHelper.setDarkTheme(value);
    _getTheme();
  }
}
