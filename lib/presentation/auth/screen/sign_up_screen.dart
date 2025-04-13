import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/presentation/auth/viewmodel/auth_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpViewModelProvider);

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
                  ref.read(signUpViewModelProvider.notifier).updatePassword(value);
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
                  ref.read(signUpViewModelProvider.notifier).updateConfirmPassword(value);
                },
              ),
              const Spacer(),
              CustomButton(
                buttonText: '회원가입',
                onPressed: _onSignUpPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSignUpPressed() {
    ref.read(signUpViewModelProvider.notifier).signUp(
      onSuccess: () {
        showDialog(
          context: context,
          builder: (_) => CustomAlertDialog(
            message: '회원가입이 완료되었습니다! 🎉',
            confirmText: '확인',
            isSuccess: true,
            onConfirm: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        );
      },
      onError: (message) {
        showDialog(
          context: context,
          builder: (_) => CustomAlertDialog(
            message: message.contains('email-already-in-use')
                ? '이미 존재하는 이메일입니다.\n로그인하시겠습니까?'
                : '회원가입에 실패했습니다. 다시 시도해주세요.',
            confirmText: message.contains('email-already-in-use') ? '로그인' : '확인',
            cancelText: message.contains('email-already-in-use') ? '닫기' : null,
            hasCancel: message.contains('email-already-in-use'),
            isSuccess: false,
            onConfirm: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/login');
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
