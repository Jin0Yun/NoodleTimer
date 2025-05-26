import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/presentation/state/timer_state.dart';
import 'package:noodle_timer/presentation/viewmodel/timer_view_model.dart';
import 'package:noodle_timer/presentation/viewmodel/auth_state.dart';
import 'package:noodle_timer/presentation/viewmodel/auth_view_model.dart';
import 'package:noodle_timer/presentation/viewmodel/history_state.dart';
import 'package:noodle_timer/presentation/viewmodel/history_view_model.dart';
import 'package:noodle_timer/presentation/viewmodel/ramen_state.dart';
import 'package:noodle_timer/presentation/viewmodel/ramen_view_model.dart';
import 'core_providers.dart';
import 'repository_providers.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  final authRepo = ref.read(authRepositoryProvider);
  final userRepo = ref.read(userRepositoryProvider);
  final logger = ref.read(loggerProvider);
  return AuthViewModel(authRepo, userRepo, logger);
});

final signUpViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) {
    final authRepo = ref.read(authRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);
    final logger = ref.read(loggerProvider);
    return AuthViewModel(authRepo, userRepo, logger);
  },
);

final ramenViewModelProvider =
    StateNotifierProvider<RamenViewModel, RamenState>((ref) {
      final repo = ref.read(ramenRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);
      final logger = ref.read(loggerProvider);
      return RamenViewModel(repo, userRepo, logger);
    });

final timerViewModelProvider =
    StateNotifierProvider<TimerViewModel, TimerState>((ref) {
      final userRepo = ref.read(userRepositoryProvider);
      final logger = ref.read(loggerProvider);
      return TimerViewModel(userRepo, logger, ref);
    });

final historyViewModelProvider =
    StateNotifierProvider<HistoryViewModel, HistoryState>((ref) {
      final userRepo = ref.read(userRepositoryProvider);
      final ramenRepo = ref.read(ramenRepositoryProvider);
      final firebaseAuth = ref.read(firebaseAuthProvider);
      final userId = firebaseAuth.currentUser?.uid ?? '';
      final logger = ref.read(loggerProvider);
      return HistoryViewModel(userRepo, ramenRepo, userId, logger, ref);
    });
