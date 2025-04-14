import 'package:flutter/material.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/presentation/auth/viewmodel/auth_provider.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/setting/widget/text_button_with_action.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/presentation/common/widget/custom_alert_dialog.dart';

class AccountSettingsSection extends ConsumerWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginViewModel = ref.read(loginViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('계정 설정', style: NoodleTextStyles.titleSmBold),
        const SizedBox(height: 16),
        TextButtonWithAction(
          title: '로그아웃',
          textColor: NoodleColors.neutral1000,
          onTap: () {
            _showActionDialog(context, '정말 로그아웃 하시겠습니까?', () async {
              await loginViewModel.logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            });
          },
        ),
        const SizedBox(height: 16),
        TextButtonWithAction(
          title: '회원 탈퇴',
          textColor: NoodleColors.error,
          onTap: () {
            _showActionDialog(context, '정말 회원 탈퇴 하시겠습니까?', () async {
              // 회원 탈퇴
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            });
          },
        ),
      ],
    );
  }

  void _showActionDialog(BuildContext context, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        message: message,
        confirmText: '확인',
        cancelText: '취소',
        hasCancel: true,
        onConfirm: () async {
          Navigator.of(context).pop();
          onConfirm();
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
