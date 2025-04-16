import 'dart:io';
import 'package:flutter/material.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/home/widget/header/custom_rounded_header.dart';
import 'package:noodle_timer/presentation/home/widget/ramen/ramen_selector_container.dart';
import 'package:noodle_timer/presentation/home/widget/timer/timer_card_with_option_selector_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlatformUtils {
  static double getPadding({required double ios, required double android}) {
    return Platform.isIOS ? ios : android;
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ramenViewModelProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ramenState = ref.watch(ramenViewModelProvider);
    final selectedRamen = ramenState.selectedRamen;

    return Scaffold(
      backgroundColor: NoodleColors.neutral100,
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
                    SizedBox(
                      height: PlatformUtils.getPadding(ios: 4, android: 18),
                    ),
                    TimerCardWithOptionSelectorContainer(
                      selectedRamen: selectedRamen
                    ),
                    SizedBox(
                      height: PlatformUtils.getPadding(ios: 22, android: 52),
                    ),
                    const RamenSelectorContainer(),
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
