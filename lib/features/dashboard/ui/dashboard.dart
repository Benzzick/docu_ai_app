import 'package:docu_ai_app/features/dashboard/providers/tab_provider.dart';
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
      TabScreen(icon: Icons.home, label: 'Home', screen: ScanScreen()),
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
        onTap: (value) {
          ref.read(tabProvider.notifier).state = value;
        },
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
