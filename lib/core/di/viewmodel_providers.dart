import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/presentation/auth/viewmodel/login_view_model.dart';
import 'package:noodle_timer/presentation/auth/viewmodel/sign_up_view_model.dart';
import 'package:noodle_timer/presentation/history/state/history_state.dart';
import 'package:noodle_timer/presentation/history/viewmodel/history_view_model.dart';
import 'package:noodle_timer/presentation/home/state/timer_state.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_view_model.dart';
import 'package:noodle_timer/presentation/home/viewmodel/timer_view_model.dart';
import 'package:noodle_timer/presentation/search/state/search_state.dart';
import 'package:noodle_timer/presentation/search/viewmodel/search_view_model.dart';
import 'package:noodle_timer/presentation/onboarding/viewmodel/noodle_preference_view_model.dart';
import 'package:noodle_timer/presentation/auth/state/login_state.dart';
import 'package:noodle_timer/presentation/auth/state/sign_up_state.dart';
import 'package:noodle_timer/presentation/home/state/ramen_state.dart';
import 'package:noodle_timer/presentation/onboarding/state/noodle_preference_state.dart';
import 'core_providers.dart';
import 'repository_providers.dart';

final signUpViewModelProvider =
    StateNotifierProvider<SignUpViewModel, SignUpState>((ref) {
      final authRepo = ref.read(authRepositoryProvider);
      final userRepo = ref.read(
        userRepositoryProvider,
      );
      final logger = ref.read(loggerProvider);
      return SignUpViewModel(authRepo, userRepo, logger);
    });

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
      final authRepo = ref.read(authRepositoryProvider);
      final logger = ref.read(loggerProvider);
      return LoginViewModel(authRepo, logger);
    });

final ramenViewModelProvider =
    StateNotifierProvider<RamenViewModel, RamenState>((ref) {
      final repo = ref.read(ramenRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);
      final logger = ref.read(loggerProvider);
      return RamenViewModel(repo, userRepo, logger);
    });

final searchViewModelProvider =
    StateNotifierProvider<SearchViewModel, SearchState>((ref) {
      final repo = ref.read(ramenRepositoryProvider);
      final logger = ref.read(loggerProvider);
      return SearchViewModel(repo, logger);
    });

final noodlePreferenceProvider = StateNotifierProvider.autoDispose<
  NoodlePreferenceViewModel,
  NoodlePreferenceState
>((ref) {
  final userRepo = ref.read(
    userRepositoryProvider,
  );
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final userId = firebaseAuth.currentUser?.uid ?? '';
  final logger = ref.read(loggerProvider);
  return NoodlePreferenceViewModel(userRepo, userId, logger);
});

final timerViewModelProvider =
    StateNotifierProvider<TimerViewModel, TimerState>((ref) {
      final userRepo = ref.read(userRepositoryProvider);
      final logger = ref.read(loggerProvider);
      return TimerViewModel(userRepo, logger, ref);
    });

final recipeHistoryViewModelProvider =
    StateNotifierProvider<RecipeHistoryViewModel, RecipeHistoryState>((ref) {
      final userRepo = ref.read(userRepositoryProvider);
      final ramenRepo = ref.read(ramenRepositoryProvider);
      final logger = ref.read(loggerProvider);
      return RecipeHistoryViewModel(userRepo, ramenRepo, logger, ref);
    });