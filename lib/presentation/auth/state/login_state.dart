class LoginState {
  final String email;
  final String password;
  final bool isLoggedIn;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoggedIn = false,
  });

  LoginState copyWith({String? email, String? password, bool? isLoggedIn}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
