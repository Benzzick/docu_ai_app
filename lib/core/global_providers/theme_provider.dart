import 'package:docu_ai_app/models/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeType>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeType> {
  ThemeNotifier() : super(ThemeType.light);

  void toggleTheme() {
    state = state == ThemeType.dark ? ThemeType.light : ThemeType.dark;
  }
}
