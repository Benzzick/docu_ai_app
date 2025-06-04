import 'package:docu_ai_app/core/app_router.dart';
import 'package:docu_ai_app/core/app_styles/app_theme.dart';
import 'package:docu_ai_app/core/global_providers/theme_provider.dart';
import 'package:docu_ai_app/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:go_router/go_router.dart';

const apiKey = '';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: apiKey);
  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeType = ref.watch(themeNotifierProvider);

    return FutureBuilder<GoRouter>(
      future: AppRouter.createRouter(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 7,
                  strokeCap: StrokeCap.round,
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
            theme: themeType == ThemeType.dark
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
          );
        }

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: themeType == ThemeType.dark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          routerConfig: snapshot.data!,
        );
      },
    );
  }
}
