import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/setting/widget/text_button_with_action.dart';

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('계정 설정', style: NoodleTextStyles.titleSmBold),
        const SizedBox(height: 16),
        TextButtonWithAction(
          title: '로그아웃',
          textColor: NoodleColors.neutral1000,
          onTap: () {
            // 로그아웃
          },
        ),
        const SizedBox(height: 16),
        TextButtonWithAction(
          title: '회원 탈퇴',
          textColor: NoodleColors.error,
          onTap: () {
            // 회원 탈퇴
          },
        ),
      ],
    );
  }
}
