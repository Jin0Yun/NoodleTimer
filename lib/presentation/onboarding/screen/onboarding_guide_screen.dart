import 'package:flutter/material.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/home/screen/home_screen.dart';
import 'package:noodle_timer/presentation/tabbar/screen/tabbar_controller.dart';

class OnboardingGuideScreen extends StatelessWidget {
  const OnboardingGuideScreen({super.key});

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
              onPressed: () => _navigateToHome(context),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
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