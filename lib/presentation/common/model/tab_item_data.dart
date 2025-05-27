import 'package:flutter/material.dart';

class TabItemData {
  final IconData icon;
  final String label;
  final bool isCenter;

  const TabItemData({
    required this.icon,
    required this.label,
    this.isCenter = false,
  });
}