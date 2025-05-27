import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/custom_app_bar.dart';
import 'package:noodle_timer/presentation/widget/setting/account_settings_section.dart';
import 'package:noodle_timer/presentation/widget/setting/app_settings_section.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '설정'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: NoodleColors.neutral400),
            const SizedBox(height: 12),
            AppSettingsSection(),
            const SizedBox(height: 12),
            Divider(color: NoodleColors.neutral400),
            const SizedBox(height: 12),
            AccountSettingsSection(),
            const SizedBox(height: 12),
            Divider(color: NoodleColors.neutral400),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
