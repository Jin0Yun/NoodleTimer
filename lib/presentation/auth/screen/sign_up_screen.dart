import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/widget/custom_text_field.dart';
import 'package:noodle_timer/presentation/common/widget/custom_alert_dialog.dart';
import 'package:noodle_timer/presentation/common/widget/custom_button.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isFormValid() {
    final state = ref.watch(signUpViewModelProvider);
    return state.email.isNotEmpty &&
        state.password.isNotEmpty &&
        state.confirmPassword.isNotEmpty &&
        state.emailError == null &&
        state.passwordError == null &&
        state.confirmError == null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpViewModelProvider);
    final isValid = _isFormValid();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: NoodleColors.neutral100,
        title: Text(
          '회원가입',
          style: NoodleTextStyles.titleSmBold.copyWith(
            color: NoodleColors.neutral1000,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                label: '이메일(아이디)',
                hint: 'example@email.com',
                controller: _emailController,
                errorMessage: state.emailError,
                onChanged: (value) {
                  ref.read(signUpViewModelProvider.notifier).updateEmail(value);
                },
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: '비밀번호',
                hint: '••••••••',
                controller: _passwordController,
                obscureText: true,
                errorMessage: state.passwordError,
                onChanged: (value) {
                  ref
                      .read(signUpViewModelProvider.notifier)
                      .updatePassword(value);
                },
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: '비밀번호 확인',
                hint: '••••••••',
                controller: _confirmPasswordController,
                obscureText: true,
                errorMessage: state.confirmError,
                onChanged: (value) {
                  ref
                      .read(signUpViewModelProvider.notifier)
                      .updateConfirmPassword(value);
                },
              ),
              const Spacer(),
              CustomButton(
                buttonText: '회원가입',
                onPressed: _onSignUpPressed,
                isEnabled: isValid,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSignUpPressed() {
    ref
        .read(signUpViewModelProvider.notifier)
        .signUp(
          onSuccess: () {
            _showAlert(
              '회원가입이 완료되었습니다! 🎉',
              isSuccess: true,
              onConfirm: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            );
          },
          onError: (message) {
            final isEmailAlreadyInUse = message.contains('이미 사용 중인 이메일입니다');

            _showAlert(
              isEmailAlreadyInUse ? '이미 존재하는 이메일입니다.\n로그인하시겠습니까?' : message,
              confirmText: isEmailAlreadyInUse ? '로그인' : '확인',
              cancelText: isEmailAlreadyInUse ? '닫기' : null,
              hasCancel: isEmailAlreadyInUse,
              isSuccess: false,
              onConfirm: () {
                Navigator.of(context).pop();
                if (isEmailAlreadyInUse) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
              onCancel:
                  isEmailAlreadyInUse
                      ? () => Navigator.of(context).pop()
                      : null,
            );
          },
        );
  }

  void _showAlert(
    String message, {
    String confirmText = '확인',
    String? cancelText,
    bool hasCancel = false,
    bool isSuccess = true,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => CustomAlertDialog(
            message: message,
            confirmText: confirmText,
            cancelText: cancelText,
            hasCancel: hasCancel,
            isSuccess: isSuccess,
            onConfirm: onConfirm ?? () => Navigator.of(context).pop(),
            onCancel: onCancel,
          ),
    );
  }
}