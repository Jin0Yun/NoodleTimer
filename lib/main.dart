import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/onboarding/screen/noodle_preference_screen.dart';
import 'package:noodle_timer/presentation/tabbar/screen/tabbar_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: NoodleColors.backgroundWhite
        ),
        home: isFirstLaunch ? const NoodlePreferenceScreen() : const TabBarController(),
      ),
    ),
  );
}
