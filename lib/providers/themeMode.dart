import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _themeModeNotifier extends StateNotifier<ThemeMode> {
  _themeModeNotifier() : super(ThemeMode.light) {
    _loadThemeMode();
  }
  Future<void> _loadThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool('isDark') ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void themeModeChange(ThemeMode tMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (tMode == ThemeMode.dark) {
      state = ThemeMode.light;
      prefs.setBool('isDark', false);
    } else {
      state = ThemeMode.dark;
      prefs.setBool('isDark', true);
    }
  }
}

final themeMode = StateNotifierProvider<_themeModeNotifier, ThemeMode>(
    (ref) => _themeModeNotifier());
