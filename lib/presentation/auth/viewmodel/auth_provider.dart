import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/data/repository/auth_repository_impl.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/presentation/auth/state/login_state.dart';
import 'package:noodle_timer/presentation/auth/state/sign_up_state.dart';
import 'package:noodle_timer/presentation/auth/viewmodel/login_view_model.dart';
import 'package:noodle_timer/presentation/auth/viewmodel/sign_up_view_model.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(firebaseAuth: FirebaseAuth.instance);
});

final signUpViewModelProvider =
StateNotifierProvider<SignUpViewModel, SignUpState>(
      (ref) => SignUpViewModel(AuthRepositoryImpl()),
);

final loginViewModelProvider =
StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  final logger = ref.read(loggerProvider);
  return LoginViewModel(authRepo, logger);
});
