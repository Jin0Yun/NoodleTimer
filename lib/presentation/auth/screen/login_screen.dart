import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/widget/custom_alert_dialog.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/custom_button.dart';
import 'package:noodle_timer/presentation/common/widget/custom_text_field.dart';
import 'package:noodle_timer/presentation/onboarding/screen/noodle_preference_screen.dart';
import 'package:noodle_timer/presentation/tabbar/screen/tabbar_controller.dart';
import 'package:noodle_timer/presentation/viewmodel/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final state = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, current) {
      final error = current.error;
      if (error != null && previous?.error != error) {
        _showErrorAlert(error);
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
                      .read(authViewModelProvider.notifier)
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
                      .read(authViewModelProvider.notifier)
                      .updatePassword(value);
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                buttonText: state.isLoading ? '로그인 중...' : '로그인',
                onPressed: _login,
                isEnabled: state.canLogin && !state.isLoading,
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
    final success = await ref.read(authViewModelProvider.notifier).login();

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
              ref.read(authViewModelProvider.notifier).resetError();
              _passwordController.clear();
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
            onConfirm: () async {
              final prefs = await SharedPreferences.getInstance();
              final needsOnboarding = prefs.getBool('needsOnboarding') ?? false;

              if (needsOnboarding) {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const NoodlePreferenceScreen(),
                    transitionDuration: Duration.zero,
                  ),
                  (route) => false,
                );
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const TabBarController(),
                    transitionDuration: Duration.zero,
                  ),
                  (route) => false,
                );
              }
            },
          ),
    );
  }
}