import 'dart:io';
import 'package:flutter/material.dart';
import 'package:noodle_timer/screen/home/custom_rounded_header.dart';
import 'package:noodle_timer/screen/home/ramen/ramen_selector_container.dart';
import 'package:noodle_timer/screen/home/timer/timer_card_with_option_selector_container.dart';
import 'package:noodle_timer/theme/noodle_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoodleColors.backgroundWhite,
      body: Column(
        children: [
          const CustomRoundedHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: getPlatformPadding(ios: 4, android: 18)),
                    const TimerCardWithOptionSelectorContainer(),
                    SizedBox(height: getPlatformPadding(ios: 22, android: 52)),
                    RamenSelectorContainer(
                      selectedCategoryIndex: selectedCategoryIndex,
                      onCategoryTap: (index) {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
double getPlatformPadding({required double ios, required double android}) {
  return Platform.isIOS ? ios : android;
}
