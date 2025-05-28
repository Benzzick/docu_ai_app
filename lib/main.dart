import 'package:docu_ai_app/core/app_router.dart';
import 'package:docu_ai_app/core/app_styles/app_theme.dart';
import 'package:docu_ai_app/core/global_providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ref.watch(themeNotifierProvider),
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.goRouter,
    );
  }
}
