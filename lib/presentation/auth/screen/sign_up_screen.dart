import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noodle_timer/presentation/auth/widget/custom_text_field.dart';
import 'package:noodle_timer/presentation/common/custom_alert_dialog.dart';
import 'package:noodle_timer/presentation/common/custom_button.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  void _validateEmail(String value) {
    final isValid = value.contains('@') && value.contains('.');
    setState(() {
      _emailError = isValid ? null : '이메일 형식이 올바르지 않습니다.';
    });
  }

  void _validatePassword(String value) {
    final isValid = value.length >= 8;
    setState(() {
      _passwordError = isValid ? null : '8자 이상 입력해주세요.';
    });

    _validateConfirmPassword(_confirmPasswordController.text);
  }

  void _validateConfirmPassword(String value) {
    final confirmText = value.trim();
    final original = _passwordController.text.trim();

    setState(() {
      if (confirmText.isEmpty) {
        _confirmError = null;
      } else {
        _confirmError = confirmText == original ? null : '비밀번호가 일치하지 않습니다.';
      }
    });
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    _validateEmail(email);
    _validatePassword(password);
    _validateConfirmPassword(confirm);

    final isValid = email.isNotEmpty &&
        password.isNotEmpty &&
        confirm.isNotEmpty &&
        _emailError == null &&
        _passwordError == null &&
        _confirmError == null;

    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

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
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (_) => CustomAlertDialog(
            message: '이미 존재하는 이메일입니다.\n로그인하시겠습니까?',
            confirmText: '로그인',
            cancelText: '닫기',
            hasCancel: true,
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                errorMessage: _emailError,
                onChanged: _validateEmail,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: '비밀번호',
                hint: '••••••••',
                controller: _passwordController,
                obscureText: true,
                errorMessage: _passwordError,
                onChanged: _validatePassword,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: '비밀번호 확인',
                hint: '••••••••',
                controller: _confirmPasswordController,
                obscureText: true,
                errorMessage: _confirmError,
                onChanged: _validateConfirmPassword,
              ),
              const Spacer(),
              CustomButton(
                buttonText: '회원가입',
                onPressed: _signUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
