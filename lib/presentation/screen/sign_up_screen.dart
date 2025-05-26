import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/widget/custom_app_bar.dart';
import 'package:noodle_timer/presentation/common/widget/custom_text_field.dart';
import 'package:noodle_timer/presentation/common/utils/dialog_utils.dart';
import 'package:noodle_timer/presentation/common/widget/custom_button.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/state/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpViewModelProvider);

    ref.listen<AuthState>(signUpViewModelProvider, (previous, current) {
      final error = current.error;
      if (error != null && previous?.error != error) {
        DialogUtils.showError(
          context,
          error,
          onConfirm: () {
            ref.read(signUpViewModelProvider.notifier).resetError();
          },
        );
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(title: '회원가입'),
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
                  ref
                      .read(signUpViewModelProvider.notifier)
                      .updateEmailWithValidation(value);
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
                      .updatePasswordWithValidation(value);
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
                isEnabled: state.isFormValid,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSignUpPressed() async {
    final success = await ref.read(signUpViewModelProvider.notifier).signUp();

    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('needsOnboarding', true);

      if (!mounted) return;
      DialogUtils.showSuccess(
        context,
        '회원가입이 완료되었습니다! 🎉',
        onConfirm: () {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        },
      );
    }
  }
}