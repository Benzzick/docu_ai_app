import 'package:docu_ai_app/core/global_providers/person_provider.dart';
import 'package:docu_ai_app/shared/widgets/back_button_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(personProvider);

    return Scaffold(
        body: Column(
      spacing: 20,
      children: [
        BackButtonAppBar(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                value: true,
                onChanged: (value) {},
                activeColor: Theme.of(context).colorScheme.secondary,
                // contentPadding: const EdgeInsets.only(left: 34, right: 22),
              ),
              Text('About'),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Text(
                  'The AI Document Scanner app is designed to help users easily scan, organize, and manage their documents using their mobile devices. The app leverages AI to enhance the scanning process, automatically detect document edges, optimize image quality, and extract text through OCR (Optical Character Recognition).'),
            ],
          ),
        ),
      ],
    ));
  }
}
