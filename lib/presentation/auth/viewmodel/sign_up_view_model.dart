import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/data/service/firestore_service.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/user_entity.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/presentation/common/utils/input_validator.dart';
import 'package:noodle_timer/presentation/auth/state/sign_up_state.dart';

class SignUpViewModel extends StateNotifier<SignUpState> {
  final AuthRepository _authRepository;
  final FirestoreService _firestoreService;
  final AppLogger _logger;

  SignUpViewModel(this._authRepository, this._firestoreService, this._logger)
    : super(const SignUpState());

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

        await _firestoreService.saveUser(user);
      }

      _logger.i('회원가입 성공: ${state.email}');
      onSuccess();
    } catch (e, st) {
      _logger.e('회원가입 중 오류 발생: $e', e, st);
      onError(e.toString());
    }
  }
}
