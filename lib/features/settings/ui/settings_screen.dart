import 'package:docu_ai_app/core/global_providers/person_provider.dart';
import 'package:docu_ai_app/core/global_providers/theme_provider.dart';
import 'package:docu_ai_app/models/enums.dart';
import 'package:docu_ai_app/shared/widgets/back_button_app_bar.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(personProvider);

    return Scaffold(
        body: Column(
      children: [
        BackButtonAppBar(),
        Expanded(
          child: SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            child: Icon(
                              Icons.person_3_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            user?.name ?? 'User',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      SwitchListTile(
                        value:
                            ref.watch(themeNotifierProvider) == ThemeType.dark
                                ? true
                                : false,
                        title: Text(
                          'Dark Mode',
                        ),

                        onChanged: (value) {
                          setState(() {
                            ref
                                .read(themeNotifierProvider.notifier)
                                .toggleTheme();
                          });
                        },
                        activeColor: Theme.of(context).colorScheme.secondary,
                        // contentPadding: const EdgeInsets.only(left: 34, right: 22),
                      ),
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      Text(
                          'The AI Document Scanner app is designed to help users easily scan, organize, and manage their documents using their mobile devices. The app leverages AI to enhance the scanning process and extract text.'),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
