import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/auth/widget/custom_text_field.dart';
import 'package:noodle_timer/presentation/auth/screen/sign_up_screen.dart';
import 'package:noodle_timer/presentation/common/custom_alert_dialog.dart';
import 'package:noodle_timer/presentation/common/custom_button.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/tabbar/screen/tabbar_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              CustomButton(
                buttonText: '로그인',
                onPressed: _login,
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
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

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showAlert('이메일과 비밀번호를 입력해주세요.');
      return;
    }

    _showAlert(
      '로그인 성공! 🎉',
      isSuccess: true,
      onConfirm: () {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TabBarController()),
        );
      },
    );
  }

  void _showAlert(String message,
      {bool isSuccess = false, VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        message: message,
        confirmText: '확인',
        isSuccess: isSuccess,
        onConfirm: onConfirm ?? () => Navigator.of(context).pop(),
      ),
    );
  }
}
