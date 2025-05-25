import 'package:noodle_timer/core/exceptions/auth_error.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/presentation/common/utils/input_validator.dart';
import 'package:noodle_timer/presentation/auth/state/login_state.dart';
import 'package:noodle_timer/presentation/common/viewmodel/base_view_model.dart';

class LoginViewModel extends BaseViewModel<LoginState> {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository, AppLogger logger)
      : super(logger, const LoginState());

  @override
  LoginState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  LoginState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  LoginState clearErrorState() {
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

  Future<bool> login() async {
    final validationError = InputValidator.validateLoginInputs(
      state.email,
      state.password,
    );
    if (validationError != null) {
      state = setErrorState(validationError);
      return false;
    }

    try {
      await runWithLoading(() async {
        await _authRepository.signIn(state.email, state.password);
        logger.i('로그인 성공: ${state.email}');
      });
      return true;
    } catch (e) {
      String errorMessage = '로그인에 실패했습니다.';
      if (e is AuthException) {
        errorMessage = e.toString();
      }
      state = setErrorState(errorMessage);
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