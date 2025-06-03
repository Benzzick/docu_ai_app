import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:docu_ai_app/models/enums.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeType>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeType> {
  static const _themeKey = 'user_theme';

  ThemeNotifier() : super(ThemeType.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTheme = prefs.getString(_themeKey);

    if (storedTheme == 'dark') {
      state = ThemeType.dark;
    } else {
      state = ThemeType.light;
    }
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = state == ThemeType.dark ? ThemeType.light : ThemeType.dark;

    await prefs.setString(
      _themeKey,
      state == ThemeType.dark ? 'dark' : 'light',
    );
  }
}
