class SignUpState {
  final String email;
  final String password;
  final String confirmPassword;
  final String? emailError;
  final String? passwordError;
  final String? confirmError;

  const SignUpState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.emailError,
    this.passwordError,
    this.confirmError,
  });

  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? emailError,
    String? passwordError,
    String? confirmError,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      emailError: emailError,
      passwordError: passwordError,
      confirmError: confirmError,
    );
  }
}
