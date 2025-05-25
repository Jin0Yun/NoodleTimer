import 'package:noodle_timer/presentation/common/state/base_state.dart';

class LoginState implements BaseState {
  final String email;
  final String password;
  final bool _isLoading;
  final String? _error;

  const LoginState({
    this.email = '',
    this.password = '',
    bool isLoading = false,
    String? error,
  }) : _isLoading = isLoading,
       _error = error;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  bool get canSubmit =>
      email.trim().isNotEmpty && password.isNotEmpty && !isLoading;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}