import 'package:flutter/material.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/user_entity.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'package:noodle_timer/presentation/common/utils/input_validator.dart';
import 'package:noodle_timer/presentation/auth/state/sign_up_state.dart';
import 'package:noodle_timer/presentation/common/viewmodel/base_view_model.dart';

class SignUpViewModel extends BaseViewModel<SignUpState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignUpViewModel(this._authRepository, this._userRepository, AppLogger logger)
      : super(logger, const SignUpState());

  @override
  SignUpState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  SignUpState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  SignUpState clearErrorState() {
    return state.copyWith(error: null);
  }

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
    if (!state.isFormValid) return;

    try {
      await runWithLoading(() async {
        final userCredential = await _authRepository.signUp(
          state.email.trim(),
          state.password,
        );

        if (userCredential.user != null) {
          final user = UserEntity(
            uid: userCredential.user!.uid,
            email: state.email.trim(),
            favoriteRamenIds: [],
            noodlePreference: NoodlePreference.none,
            eggPreference: EggPreference.none,
            createdAt: DateTime.now(),
          );

          await _userRepository.saveUser(user);
        }

        logger.i('회원가입 성공: ${state.email}');
      });
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }
}