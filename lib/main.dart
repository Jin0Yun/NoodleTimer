import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/firebase_options.dart';
import 'package:noodle_timer/presentation/auth/screen/login_screen.dart';
import 'package:noodle_timer/presentation/auth/screen/sign_up_screen.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/onboarding/screen/noodle_preference_screen.dart';
import 'package:noodle_timer/presentation/onboarding/screen/onboarding_guide_screen.dart';
import 'package:noodle_timer/presentation/setting/screen/setting_screen.dart';
import 'package:noodle_timer/presentation/tabbar/screen/tabbar_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final isLoggedIn = FirebaseAuth.instance.currentUser != null;

  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: NoodleColors.neutral100),
        initialRoute:
            isLoggedIn
                ? (isFirstLaunch
                    ? AppRoutes.onboardingPreference
                    : AppRoutes.home)
                : AppRoutes.login,
        routes: {
          AppRoutes.home: (_) => const TabBarController(),
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.signup: (_) => const SignUpScreen(),
          AppRoutes.onboardingPreference: (_) => const NoodlePreferenceScreen(),
          AppRoutes.onboardingGuide: (_) => const OnboardingGuideScreen(),
          AppRoutes.settings: (_) => const SettingScreen(),
        },
      ),
    ),
  );
}
