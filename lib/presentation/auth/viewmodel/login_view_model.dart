import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/presentation/common/utils/input_validator.dart';
import 'package:noodle_timer/presentation/auth/state/login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  final AppLogger _logger;

  LoginViewModel(this._authRepository, this._logger) : super(const LoginState());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  String? validateInputs() {
    return InputValidator.validateLoginInputs(state.email, state.password);
  }

  Future<String?> login() async {
    final error = validateInputs();
    if (error != null) {
      _logger.d('유효성 검사 실패 - $error');
      return error;
    }

    try {
      await _authRepository.signIn(state.email, state.password);
      _logger.i('로그인 성공: ${state.email}');
      return null;
    } catch (e, st) {
      if (e is FirebaseAuthException) {
        _logger.e('[Login Error] code: ${e.code}, message: ${e.message}', e, st);
        switch (e.code) {
          case 'user-not-found':
            return '존재하지 않는 계정입니다.';
          case 'wrong-password':
            return '비밀번호가 일치하지 않습니다.';
          case 'invalid-email':
            return '이메일 형식이 올바르지 않습니다.';
          case 'invalid-credential':
            return '이메일 또는 비밀번호가 잘못되었습니다.';
        }
      }

      _logger.e('로그인 중 알 수 없는 에러 발생', e, st);
      return '로그인에 실패했습니다.';
    }
  }
}
