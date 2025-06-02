import 'package:docu_ai_app/core/global_providers/tab_provider.dart';
import 'package:docu_ai_app/features/docs/ui/doc_screen.dart';
import 'package:docu_ai_app/features/home/ui/home_screen.dart';
import 'package:docu_ai_app/features/scan/ui/scan_screen.dart';
import 'package:docu_ai_app/models/tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final List<TabScreen> tabs = [
      TabScreen(icon: Icons.home_rounded, label: 'Home', screen: HomeScreen()),
      TabScreen(
          icon: Icons.camera_alt_rounded, label: 'Scan', screen: ScanScreen()),
      TabScreen(
          icon: Icons.description_rounded, label: 'Docs', screen: DocScreen()),
    ];

    final tabIndex = ref.watch(tabProvider);

    return Scaffold(
      body: IndexedStack(
        index: tabIndex,
        children: tabs.map(
          (tab) {
            return tab.screen;
          },
        ).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: tabIndex,
        onTap: (value) {
          ref.read(tabProvider.notifier).state = value;
        },
        selectedLabelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
        items: tabs.map(
          (tab) {
            return BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.label,
            );
          },
        ).toList(),
      ),
    );
  }
}
