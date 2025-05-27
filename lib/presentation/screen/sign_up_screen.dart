import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/widget/custom_app_bar.dart';
import 'package:noodle_timer/presentation/common/widget/custom_text_field.dart';
import 'package:noodle_timer/presentation/common/utils/dialog_utils.dart';
import 'package:noodle_timer/presentation/common/widget/custom_button.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).resetForm();
      ref
          .read(authViewModelProvider.notifier)
          .setCurrentScreen(AuthScreenType.signup);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, current) {
      if (current.currentScreen != AuthScreenType.signup) return;

      final error = current.error;
      if (error != null && previous?.error != error) {
        DialogUtils.showError(
          context,
          error,
          onConfirm: () {
            ref.read(authViewModelProvider.notifier).resetError();
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
                      .read(authViewModelProvider.notifier)
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
                      .read(authViewModelProvider.notifier)
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
                      .read(authViewModelProvider.notifier)
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
    final success = await ref.read(authViewModelProvider.notifier).signUp();

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