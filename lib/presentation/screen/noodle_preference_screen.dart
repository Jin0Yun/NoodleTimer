import 'package:flutter/material.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/custom_app_bar.dart';
import 'package:noodle_timer/presentation/common/widget/custom_button.dart';
import 'package:noodle_timer/presentation/common/widget/preference_option_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';

class NoodlePreferenceScreen extends ConsumerStatefulWidget {
  const NoodlePreferenceScreen({super.key});

  @override
  ConsumerState<NoodlePreferenceScreen> createState() =>
      _NoodlePreferenceScreenState();
}

class _NoodlePreferenceScreenState
    extends ConsumerState<NoodlePreferenceScreen> {
  bool? isKkodulSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoodleColors.neutral100,
      appBar: const CustomAppBar(title: '라면 취향 선택'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 52),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                Text.rich(
                  TextSpan(
                    text: '원하는 ',
                    style: NoodleTextStyles.titleMd.copyWith(
                      color: NoodleColors.neutral1000,
                    ),
                    children: [
                      TextSpan(
                        text: '면발',
                        style: NoodleTextStyles.titleMdBold.copyWith(
                          color: NoodleColors.neutral1000,
                        ),
                      ),
                      TextSpan(
                        text: '을\n선택해 주세요!',
                        style: NoodleTextStyles.titleMd.copyWith(
                          color: NoodleColors.neutral1000,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    PreferenceOptionCard(
                      imagePath: 'assets/image/kodul.png',
                      label: '꼬들면',
                      isSelected: isKkodulSelected == true,
                      onTap: () {
                        setState(() {
                          isKkodulSelected = true;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    PreferenceOptionCard(
                      imagePath: 'assets/image/peojin.png',
                      label: '퍼진면',
                      isSelected: isKkodulSelected == false,
                      onTap: () {
                        setState(() {
                          isKkodulSelected = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: NoodleColors.neutral800,
                ),
                SizedBox(width: 4),
                Text(
                  '선택에 따라 타이머가 자동으로 설정됩니다!',
                  style: NoodleTextStyles.titleSm.copyWith(
                    color: NoodleColors.neutral800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: CustomButton(
          buttonText: '다음',
          isEnabled: isKkodulSelected != null,
          onPressed: isKkodulSelected == null ? null : _onNextPressed,
        ),
      ),
    );
  }

  Future<void> _onNextPressed() async {
    final noodlePreference =
        isKkodulSelected == true
            ? NoodlePreference.kodul
            : NoodlePreference.peojin;

    await ref
        .read(historyViewModelProvider.notifier)
        .updateNoodlePreference(noodlePreference);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);

    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.onboardingGuide);
  }
}