import 'dart:io';

import 'package:docu_ai_app/features/auth/ui/auth_screen.dart';
import 'package:docu_ai_app/features/dashboard/ui/dashboard.dart';
import 'package:docu_ai_app/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:docu_ai_app/features/preview/ui/edit_pdf.dart';
import 'package:docu_ai_app/features/preview/ui/preview_pdf.dart';
import 'package:docu_ai_app/features/preview/ui/preview_scanned_image.dart';
import 'package:docu_ai_app/features/settings/ui/settings_screen.dart';
import 'package:docu_ai_app/models/pdf.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static Future<GoRouter> createRouter() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    final email = prefs.getString('user_email');

    final initialLocation =
        (name != null && email != null) ? '/dash' : '/onboarding';

    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => OnboardingScreen(),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => AuthScreen(),
        ),
        GoRoute(
          path: '/dash',
          builder: (context, state) => Dashboard(),
        ),
        GoRoute(
          path: '/preview-image',
          builder: (context, state) =>
              PreviewScannedImage(image: state.extra as File),
        ),
        GoRoute(
          path: '/preview-pdf',
          builder: (context, state) => PreviewPdf(pdf: state.extra as Pdf),
        ),
        GoRoute(
          path: '/edit-pdf',
          builder: (context, state) => EditPdf(pdf: state.extra as Pdf),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(),
        ),
      ],
    );
  }
}
