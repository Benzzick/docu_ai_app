import 'package:docu_ai_app/core/app_styles/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier(AppTheme.lightTheme);
});


class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier(super._state);

  void toggleTheme() {
    state =
        state == AppTheme.lightTheme ? AppTheme.darkTheme : AppTheme.lightTheme;
  }
}
