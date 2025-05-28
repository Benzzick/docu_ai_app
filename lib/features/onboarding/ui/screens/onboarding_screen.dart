import 'package:docu_ai_app/features/onboarding/ui/widgets/onboarding_banner.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController bannersController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    bannersController = PageController();
  }

  @override
  void dispose() {
    bannersController.dispose();
    super.dispose();
  }

  final List<Widget> banners = [
    OnboardingBanner(
        imagePath: 'assets/images/onboarding/image-2.webp',
        title: 'Scan Documents with AI',
        description:
            'Turn physical documents into digital files with just a tap.'),
    OnboardingBanner(
        imagePath: 'assets/images/onboarding/image-1.webp',
        title: 'Extract Text Instantly',
        description:
            'Convert printed text into searchable digital content with OCR'),
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
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
              spacing: 30,
              children: [
                SizedBox(
                  height: height * 0.5,
                  child: PageView.builder(
                    controller: bannersController,
                    itemBuilder: (context, index) {
                      return banners[index];
                    },
                    itemCount: banners.length,
                    onPageChanged: (value) => setState(() {
                      currentPage = value;
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    spacing: 30,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/auth');
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: currentPage == banners.length - 1
                                ? const Text(
                                    'Get Started',
                                    key: ValueKey('GET'),
                                  )
                                : const Text(
                                    'Next',
                                    key: ValueKey('value'),
                                  ),
                          ),
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: bannersController,
                        count: banners.length,
                        effect: ColorTransitionEffect(
                          activeDotColor: Theme.of(context).colorScheme.primary,
                          dotColor: Colors.grey,
                          dotHeight: 10,
                          dotWidth: 30,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
