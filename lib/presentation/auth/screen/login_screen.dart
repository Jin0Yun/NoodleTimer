import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/widget/custom_alert_dialog.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/custom_button.dart';
import 'package:noodle_timer/presentation/common/widget/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoodleColors.neutral100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/logo.png',
                width: 120,
                height: 120,
                color: NoodleColors.primary,
              ),
              const SizedBox(height: 60),
              CustomTextField(
                label: '이메일(아이디)',
                hint: 'example@email.com',
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: '비밀번호',
                hint: '••••••••',
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              CustomButton(buttonText: '로그인', onPressed: _login),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                },
                child: Text(
                  '회원가입',
                  style: NoodleTextStyles.titleXSmBold.copyWith(
                    color: NoodleColors.neutral900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    ref
        .read(loginViewModelProvider.notifier)
        .updateEmail(_emailController.text.trim());
    ref
        .read(loginViewModelProvider.notifier)
        .updatePassword(_passwordController.text);

    final error = await ref.read(loginViewModelProvider.notifier).login();

    if (!mounted) return;

    if (error != null) {
      _showAlert(error);
    } else {
      _showAlert(
        '로그인 성공! 🎉',
        isSuccess: true,
        onConfirm: () {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, AppRoutes.onboardingPreference);
        },
      );
    }
  }

  void _showAlert(
    String message, {
    bool isSuccess = false,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => CustomAlertDialog(
            message: message,
            confirmText: '확인',
            isSuccess: isSuccess,
            onConfirm: onConfirm ?? () => Navigator.of(context).pop(),
          ),
    );
  }
}
