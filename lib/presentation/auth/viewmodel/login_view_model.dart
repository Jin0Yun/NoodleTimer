import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/exceptions/auth_error.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/presentation/common/utils/input_validator.dart';
import 'package:noodle_timer/presentation/auth/state/login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  final AppLogger _logger;

  LoginViewModel(this._authRepository, this._logger)
    : super(const LoginState());

  void updateEmail(String email) {
    state = state.copyWith(email: email, errorMessage: null);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password, errorMessage: null);
  }

  Future<bool> login() async {
    final validationError = InputValidator.validateLoginInputs(
      state.email,
      state.password,
    );
    if (validationError != null) {
      state = state.copyWith(errorMessage: validationError);
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.signIn(state.email, state.password);
      _logger.i('로그인 성공: ${state.email}');
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e, st) {
      _logger.e('로그인 실패', e, st);

      String errorMessage = '로그인에 실패했습니다.';
      if (e is AuthError) {
        errorMessage = e.message;
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> logout() async {
    try {
      await _authRepository.signOut();
      _logger.i('로그아웃 성공');
    } catch (e, st) {
      _logger.e('로그아웃 실패', e, st);
    }
  }
}