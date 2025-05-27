import 'package:flutter/material.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/utils/dialog_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/presentation/common/widget/text_button_with_action.dart';

class AccountSettingsSection extends ConsumerWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('계정 설정', style: NoodleTextStyles.titleSmBold),
        const SizedBox(height: 16),
        TextButtonWithAction(
          title: '로그아웃',
          textColor: NoodleColors.neutral1000,
          onTap: () {
            DialogUtils.showConfirm(
              context,
              '정말 로그아웃 하시겠습니까?',
              onConfirm: () => _logout(context, ref),
            );
          },
        ),
        const SizedBox(height: 16),
        TextButtonWithAction(
          title: '회원 탈퇴',
          textColor: NoodleColors.error,
          onTap: () {
            DialogUtils.showConfirm(
              context,
              '정말 회원 탈퇴 하시겠습니까?',
              onConfirm: () => _deleteAccount(context),
            );
          },
        ),
      ],
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authViewModelProvider.notifier).logout();

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }
}