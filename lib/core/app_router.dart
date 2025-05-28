import 'dart:io';

import 'package:docu_ai_app/features/auth/ui/auth_screen.dart';
import 'package:docu_ai_app/features/dashboard/ui/dashboard.dart';
import 'package:docu_ai_app/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:docu_ai_app/features/preview/ui/edit_pdf.dart';
import 'package:docu_ai_app/features/preview/ui/preview_pdf.dart';
import 'package:docu_ai_app/features/preview/ui/preview_scanned_image.dart';
import 'package:docu_ai_app/models/pdf.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter goRouter =
      GoRouter(initialLocation: '/onboarding', routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) {
        return OnboardingScreen();
      },
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) {
        return AuthScreen();
      },
    ),
    GoRoute(
      path: '/dash',
      builder: (context, state) {
        return Dashboard();
      },
    ),
    GoRoute(
      path: '/preview-image',
      builder: (context, state) {
        return PreviewScannedImage(image: state.extra as File);
      },
    ),
    GoRoute(
      path: '/preview-pdf',
      builder: (context, state) {
        return PreviewPdf(pdf: state.extra as Pdf);
      },
    ),
    GoRoute(
      path: '/edit-pdf',
      builder: (context, state) {
        return EditPdf(pdf: state.extra as Pdf);
      },
    )
  ]);
}
