import 'package:flutter/material.dart';

class TabScreen {
  TabScreen({
    required this.icon,
    required this.label,
    required this.screen,
  });
  final IconData icon;
  final String label;
  final Widget screen;
}
