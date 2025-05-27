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
            DialogUtils.showPasswordConfirm(
              context,
              '회원 탈퇴 시 모든 데이터가 삭제됩니다.\n보안을 위해 비밀번호를 입력해주세요.',
              onConfirm:
                  (password) => _confirmDeleteAccount(context, ref, password),
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

  Future<void> _confirmDeleteAccount(
    BuildContext context,
    WidgetRef ref,
    String password,
  ) async {
    if (password.isEmpty) {
      DialogUtils.showError(context, '비밀번호를 입력해주세요.');
      return;
    }

    try {
      final success = await ref
          .read(authViewModelProvider.notifier)
          .deleteAccountWithPassword(password);

      if (success && context.mounted) {
        DialogUtils.showSuccess(
          context,
          '회원탈퇴가 완료되었습니다.',
          onConfirm: () {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        String errorMessage = '회원탈퇴에 실패했습니다.';
        if (e.toString().contains('wrong-password')) {
          errorMessage = '비밀번호가 올바르지 않습니다.';
        }
        DialogUtils.showError(context, errorMessage);
      }
    }
  }
}