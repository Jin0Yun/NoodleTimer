import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/custom_switch.dart';

class AppSettingsSection extends StatefulWidget {
  const AppSettingsSection({super.key});

  @override
  _AppSettingsSectionState createState() => _AppSettingsSectionState();
}

class _AppSettingsSectionState extends State<AppSettingsSection> {
  bool _pushNotificationEnabled = false;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('앱 설정', style: NoodleTextStyles.titleSmBold),
        const SizedBox(height: 8),
        CustomSwitch(
          title: '푸시 알림',
          value: _pushNotificationEnabled,
          onChanged: (value) {
            setState(() {
              _pushNotificationEnabled = value;
            });
          },
        ),
        CustomSwitch(
          title: '다크모드',
          value: _darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _darkModeEnabled = value;
            });
          },
        ),
      ],
    );
  }
}
