import 'package:flutter/material.dart';

class OnboardingBanner extends StatelessWidget {
  const OnboardingBanner(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.description});

  final String imagePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(imagePath),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
