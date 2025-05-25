import 'package:noodle_timer/presentation/common/state/base_state.dart';

class AuthState implements BaseState {
  final String email;
  final String password;
  final String confirmPassword;
  final String? emailError;
  final String? passwordError;
  final String? confirmError;
  final bool _isLoading;
  final String? _error;

  const AuthState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.emailError,
    this.passwordError,
    this.confirmError,
    bool isLoading = false,
    String? error,
  }) : _isLoading = isLoading,
        _error = error;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  bool get canLogin => email.trim().isNotEmpty && password.isNotEmpty && !isLoading;

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
    );
  }
}