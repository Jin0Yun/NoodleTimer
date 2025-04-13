import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/data/repository/auth_repository_impl.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/presentation/auth/screen/input_validator.dart';
import 'package:noodle_timer/presentation/auth/screen/sign_up_state.dart';

final signUpViewModelProvider =
    StateNotifierProvider<SignUpViewModel, SignUpState>(
      (ref) => SignUpViewModel(AuthRepositoryImpl()),
    );

class SignUpViewModel extends StateNotifier<SignUpState> {
  final AuthRepository _repository;

  SignUpViewModel(this._repository) : super(const SignUpState());

  void updateEmail(String value) {
    final error = InputValidator.validateEmail(value);
    state = state.copyWith(email: value, emailError: error);
  }

  void updatePassword(String value) {
    final error = InputValidator.validatePassword(value);
    state = state.copyWith(password: value, passwordError: error);
  }

  void updateConfirmPassword(String value) {
    final error = InputValidator.validatePasswordConfirmation(
      state.password,
      value,
    );
    state = state.copyWith(confirmPassword: value, confirmError: error);
  }

  Future<void> signUp({
    required VoidCallback onSuccess,
    required Function(String message) onError,
  }) async {
    final isValid =
        state.email.isNotEmpty &&
        state.password.isNotEmpty &&
        state.confirmPassword.isNotEmpty &&
        state.emailError == null &&
        state.passwordError == null &&
        state.confirmError == null;

    if (!isValid) return;

    try {
      await _repository.signUp(state.email.trim(), state.password);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }
}
