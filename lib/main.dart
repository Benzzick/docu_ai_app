import 'package:docu_ai_app/core/app_router.dart';
import 'package:docu_ai_app/core/app_styles/app_theme.dart';
import 'package:docu_ai_app/core/global_providers/theme_provider.dart';
import 'package:docu_ai_app/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

const apiKey = 'AIzaSyDhiK3uttfw0aBn7lj3BeR_ofhArLgfcX0';

void main() {
  Gemini.init(apiKey: apiKey);
  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeType = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: themeType == ThemeType.dark
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
      routerConfig: AppRouter.goRouter,
    );
  }
}
