import 'package:noodle_timer/presentation/state/base_state.dart';

enum AuthScreenType { login, signup }

class AuthState implements BaseState {
  final String email;
  final String password;
  final String confirmPassword;
  final String? emailError;
  final String? passwordError;
  final String? confirmError;
  final bool _isLoading;
  final String? _error;
  final AuthScreenType currentScreen;
  final bool isDialogShowing;

  const AuthState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.emailError,
    this.passwordError,
    this.confirmError,
    bool isLoading = false,
    String? error,
    this.currentScreen = AuthScreenType.login,
    this.isDialogShowing = false,
  }) : _isLoading = isLoading,
       _error = error;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  bool get canLogin =>
      email.trim().isNotEmpty && password.isNotEmpty && !isLoading;

  bool get isFormValid =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      emailError == null &&
      passwordError == null &&
      confirmError == null;

  AuthState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? emailError,
    String? passwordError,
    String? confirmError,
    bool? isLoading,
    String? error,
    AuthScreenType? currentScreen,
    bool? isDialogShowing,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      emailError: emailError,
      passwordError: passwordError,
      confirmError: confirmError,
      isLoading: isLoading ?? _isLoading,
      error: error,
      currentScreen: currentScreen ?? this.currentScreen,
      isDialogShowing: isDialogShowing ?? this.isDialogShowing,
    );
  }
}