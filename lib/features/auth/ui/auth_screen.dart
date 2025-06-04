import 'package:docu_ai_app/core/global_providers/person_provider.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Stack(
          children: [
            Positioned.fill(
              child: FloatingBubbles.alwaysRepeating(
                noOfBubbles: 15,
                colorsOfBubbles: [
                  Theme.of(context).colorScheme.secondary,
                ],
                sizeFactor: 0.2,
                opacity: 50,
                paintingStyle: PaintingStyle.fill,
                strokeWidth: 8,
                shape: BubbleShape.circle,
                speed: BubbleSpeed.normal,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/auth/logo.webp'),
                SizedBox(
                  height: 70,
                  child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(personProvider.notifier)
                            .loginWithGoogle();
                        final person = ref.read(personProvider);
                        if (person != null) {
                          context.go('/dash');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Theme.of(context).colorScheme.surface,
                        elevation: 5,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Text(
                            'Sign In with',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Image.asset(
                            'assets/images/auth/google.webp',
                            color: Colors.white,
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Once you're done close the auth screen in order not to be redirected again!",
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
