import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/usecase/auth_usecase.dart';
import 'package:noodle_timer/presentation/common/utils/input_validator.dart';
import 'package:noodle_timer/presentation/viewmodel/base_view_model.dart';
import 'package:noodle_timer/presentation/state/auth_state.dart';

class AuthViewModel extends BaseViewModel<AuthState> {
  final AuthUseCase _authUseCase;

  AuthViewModel(this._authUseCase, AppLogger logger)
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
    return state.copyWith(error: null, isDialogShowing: false);
  }

  void setDialogShowing(bool showing) {
    state = state.copyWith(isDialogShowing: showing);
  }

  void setCurrentScreen(AuthScreenType screenType) {
    state = state.copyWith(currentScreen: screenType);
  }

  void resetForm() {
    state = const AuthState();
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
      await _authUseCase.login(state.email, state.password);
      state = setLoadingState(false);
      return true;
    } catch (e) {
      state = setErrorState(e.toString());
      state = setLoadingState(false);
      return false;
    }
  }

  Future<bool> signUp() async {
    if (!state.isFormValid) return false;

    state = setLoadingState(true);
    try {
      await _authUseCase.signUp(state.email.trim(), state.password);
      state = setLoadingState(false);
      return true;
    } catch (e) {
      state = setErrorState(e.toString());
      state = setLoadingState(false);
      return false;
    }
  }

  Future<void> logout() async {
    await runWithLoading(() async {
      await _authUseCase.logout();
    }, showLoading: false);
  }
}