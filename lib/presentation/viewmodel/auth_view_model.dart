import 'package:noodle_timer/core/exceptions/auth_exception.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/user_entity.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'package:noodle_timer/presentation/common/utils/input_validator.dart';
import 'package:noodle_timer/presentation/viewmodel/base_view_model.dart';
import 'package:noodle_timer/presentation/viewmodel/auth_state.dart';

class AuthViewModel extends BaseViewModel<AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthViewModel(this._authRepository, this._userRepository, AppLogger logger)
      : super(logger, const AuthState());

  @override
  AuthState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  AuthState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  AuthState clearErrorState() {
    return state.copyWith(error: null);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
    resetError();
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
    resetError();
  }

  void updateConfirmPassword(String value) {
    final error = InputValidator.validatePasswordConfirmation(
      state.password,
      value,
    );
    state = state.copyWith(confirmPassword: value, confirmError: error);
  }

  void updateEmailWithValidation(String value) {
    final error = InputValidator.validateEmail(value);
    state = state.copyWith(email: value, emailError: error);
  }

  void updatePasswordWithValidation(String value) {
    final error = InputValidator.validatePassword(value);
    state = state.copyWith(password: value, passwordError: error);
  }

  Future<bool> login() async {
    final validationError = InputValidator.validateLoginInputs(
      state.email,
      state.password,
    );
    if (validationError != null) {
      state = setErrorState(validationError);
      return false;
    }

    state = setLoadingState(true);
    try {
      await _authRepository.signIn(state.email, state.password);
      logger.i('로그인 성공: ${state.email}');
      state = setLoadingState(false);
      return true;
    } catch (e) {
      String errorMessage = '로그인에 실패했습니다.';
      if (e is AuthException) {
        errorMessage = e.toString();
      }
      logger.e('로그인 실패: ${state.email}', e);
      state = setErrorState(errorMessage);
      state = setLoadingState(false);
      return false;
    }
  }

  Future<bool> signUp() async {
    if (!state.isFormValid) return false;

    state = setLoadingState(true);
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

        await _userRepository.saveUser(user);
      }

      logger.i('회원가입 성공: ${state.email}');
      state = setLoadingState(false);
      return true;
    } catch (e) {
      String errorMessage = '회원가입에 실패했습니다.';
      if (e is AuthException) {
        errorMessage = e.toString();
      }
      logger.e('회원가입 실패: ${state.email}', e);
      state = setErrorState(errorMessage);
      state = setLoadingState(false);
      return false;
    }
  }

  Future<void> logout() async {
    await runWithLoading(() async {
      await _authRepository.signOut();
      logger.i('로그아웃 성공');
    }, showLoading: false);
  }
}