import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'theme_persistence_keys.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs)
      : super(
          ThemeState(
            themeMode: _prefs.getBool(ThemePersistenceKeys.isDarkMode) == true
                ? ThemeMode.dark
                : ThemeMode.light,
          ),
        );

  void setDarkMode(bool isDark) {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    _prefs.setBool(ThemePersistenceKeys.isDarkMode, isDark);
    emit(ThemeState(themeMode: mode));
  }

  void toggleDarkMode() {
    setDarkMode(!state.isDarkMode);
  }
}

