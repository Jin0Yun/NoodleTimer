import 'package:flutter/material.dart';
import 'package:noodle_timer/screen/home_screen.dart';
import 'package:noodle_timer/theme/noodle_colors.dart';

class OnboardingGuideScreen extends StatelessWidget {
  const OnboardingGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const HomeScreen(),
          Container(color: NoodleColors.backgroundOverlay),
          Positioned(
            top: 360,
            right: 20,
            child: Image.asset('assets/image/guide_01.png', width: 200),
          ),
          Positioned(
            top: 440,
            left: 10,
            right: 10,
            child: Image.asset('assets/image/guide_02.png', height: 65),
          ),
          Positioned(
            bottom: 200,
            left: 80,
            child: Image.asset('assets/image/guide_03.png', width: 190),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            child: Image.asset('assets/image/guide_04.png', width: 150),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 30,
                color: NoodleColors.backgroundWhite,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HomeScreen(),
                    transitionsBuilder: (_, anim, __, child) {
                      return FadeTransition(opacity: anim, child: child);
                    },
                    transitionDuration: Duration(milliseconds: 300),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
