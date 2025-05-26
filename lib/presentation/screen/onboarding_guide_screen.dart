import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/screen/home_screen.dart';
import 'package:noodle_timer/presentation/screen/tabbar_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingGuideScreen extends StatefulWidget {
  const OnboardingGuideScreen({super.key});

  @override
  State<OnboardingGuideScreen> createState() => _OnboardingGuideScreenState();
}

class _OnboardingGuideScreenState extends State<OnboardingGuideScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallDevice = screenSize.height < 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const HomeScreen(),
          Container(color: NoodleColors.overlay),
          Positioned(
            top:
                isSmallDevice
                    ? screenSize.height * 0.45
                    : screenSize.height * 0.43,
            right: screenSize.width * 0.03,
            child: Image.asset(
              'assets/image/guide_01.png',
              width: screenSize.width * 0.5,
            ),
          ),
          Positioned(
            top:
                isSmallDevice
                    ? screenSize.height * 0.57
                    : screenSize.height * 0.52,
            left: screenSize.width * 0.1,
            right: screenSize.width * 0.1,
            child: Image.asset(
              'assets/image/guide_02.png',
              height: isSmallDevice ? 55 : 65,
            ),
          ),
          Positioned(
            bottom:
                isSmallDevice
                    ? screenSize.height * 0.1
                    : screenSize.height * 0.2,
            left: screenSize.width * 0.2,
            child: Image.asset(
              'assets/image/guide_03.png',
              width: screenSize.width * 0.6,
            ),
          ),
          Positioned(
            bottom: isSmallDevice ? -30 : screenSize.height * 0.12,
            left:
                isSmallDevice
                    ? screenSize.width * 0.06
                    : screenSize.width * 0.04,
            child: Image.asset(
              'assets/image/guide_04.png',
              width: screenSize.width * 0.4,
              height: screenSize.width * 0.4,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 30,
                color: NoodleColors.neutral100,
              ),
              onPressed: () => _navigateToHome(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToHome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('needsOnboarding', false);

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const TabBarController(),
        transitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }
}