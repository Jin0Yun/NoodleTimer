import 'package:flutter/material.dart';
import 'package:noodle_timer/screen/home/home_screen.dart';
import 'package:noodle_timer/screen/onboarding/noodle_preference_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(
    MaterialApp(
      home: isFirstLaunch ? const NoodlePreferenceScreen() : const HomeScreen(),
    ),
  );
}
