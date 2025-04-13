import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/data/repository/auth_repository_impl.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/presentation/auth/screen/input_validator.dart';
import 'package:noodle_timer/presentation/auth/screen/login_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(firebaseAuth: FirebaseAuth.instance);
});

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>(
      (ref) => LoginViewModel(ref.read(authRepositoryProvider)),
    );

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository) : super(const LoginState());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  String? validateInputs() {
    return InputValidator.validateLoginInputs(state.email, state.password);
  }

  Future<String?> login() async {
    final error = validateInputs();
    if (error != null) return error;

    try {
      await _authRepository.signIn(state.email, state.password);
      return null;
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('[Login Error] code: ${e.code}, message: ${e.message}');
        if (e.code == 'user-not-found') return '존재하지 않는 계정입니다.';
        if (e.code == 'wrong-password') return '비밀번호가 일치하지 않습니다.';
        if (e.code == 'invalid-email') return '이메일 형식이 올바르지 않습니다.';
        if (e.code == 'invalid-credential') return '이메일 또는 비밀번호가 잘못되었습니다.';
      }
      return '로그인에 실패했습니다.';
    }
  }
}
