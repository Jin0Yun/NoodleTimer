import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/auth/state/login_state.dart';
import 'package:noodle_timer/presentation/common/widget/custom_alert_dialog.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/custom_button.dart';
import 'package:noodle_timer/presentation/common/widget/custom_text_field.dart';
import 'package:noodle_timer/presentation/onboarding/screen/noodle_preference_screen.dart';
import 'package:noodle_timer/presentation/onboarding/screen/onboarding_guide_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);

    ref.listen<LoginState>(loginViewModelProvider, (previous, current) {
      if (current.errorMessage != null) {
        _showErrorAlert(current.errorMessage!);
      }
    });

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
                onChanged: (value) {
                  ref
                      .read(loginViewModelProvider.notifier)
                      .updateEmail(value.trim());
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: '비밀번호',
                hint: '••••••••',
                controller: _passwordController,
                obscureText: true,
                onChanged: (value) {
                  ref
                      .read(loginViewModelProvider.notifier)
                      .updatePassword(value);
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                buttonText: state.isLoading ? '로그인 중...' : '로그인',
                onPressed: _login,
                isEnabled: state.isFormValid && !state.isLoading,
              ),
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
    final success = await ref.read(loginViewModelProvider.notifier).login();

    if (success) {
      _showSuccessAlert();
    }
  }

  void _showErrorAlert(String message) {
    showDialog(
      context: context,
      builder:
          (_) => CustomAlertDialog(
            message: message,
            confirmText: '확인',
            isSuccess: false,
            onConfirm: () {
              Navigator.of(context).pop();
              ref.read(loginViewModelProvider.notifier).clearError();
            },
          ),
    );
  }

  void _showSuccessAlert() {
    showDialog(
      context: context,
      builder:
          (_) => CustomAlertDialog(
            message: '로그인 성공! 🎉',
            confirmText: '확인',
            isSuccess: true,
            onConfirm: () {
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const NoodlePreferenceScreen(),
                  transitionDuration: Duration.zero,
                ),
                (route) => false,
              );
            },
          ),
    );
  }
}
