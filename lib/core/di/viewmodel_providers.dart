import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/presentation/state/timer_state.dart';
import 'package:noodle_timer/presentation/viewmodel/timer_view_model.dart';
import 'package:noodle_timer/presentation/state/auth_state.dart';
import 'package:noodle_timer/presentation/viewmodel/auth_view_model.dart';
import 'package:noodle_timer/presentation/state/history_state.dart';
import 'package:noodle_timer/presentation/viewmodel/history_view_model.dart';
import 'package:noodle_timer/presentation/state/ramen_state.dart';
import 'package:noodle_timer/presentation/viewmodel/ramen_view_model.dart';
import 'core_providers.dart';
import 'usecase_providers.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  final authUseCase = ref.watch(authUseCaseProvider);
  final logger = ref.watch(loggerProvider);
  return AuthViewModel(authUseCase, logger);
});

final ramenViewModelProvider =
    StateNotifierProvider<RamenViewModel, RamenState>((ref) {
      final ramenUseCase = ref.watch(ramenUseCaseProvider);
      final cookHistoryUseCase = ref.watch(cookHistoryUseCaseProvider);
      final logger = ref.watch(loggerProvider);
      return RamenViewModel(ramenUseCase, cookHistoryUseCase, logger);
    });

final timerViewModelProvider =
    StateNotifierProvider<TimerViewModel, TimerState>((ref) {
      final cookHistoryUseCase = ref.watch(cookHistoryUseCaseProvider);
      final logger = ref.watch(loggerProvider);
      return TimerViewModel(cookHistoryUseCase, logger, ref);
    });

final historyViewModelProvider =
    StateNotifierProvider<HistoryViewModel, HistoryState>((ref) {
      final userUseCase = ref.watch(userUseCaseProvider);
      final ramenUseCase = ref.watch(ramenUseCaseProvider);
      final cookHistoryUseCase = ref.watch(cookHistoryUseCaseProvider);
      final firebaseAuth = ref.watch(firebaseAuthProvider);
      final userId = firebaseAuth.currentUser?.uid ?? '';
      final logger = ref.watch(loggerProvider);
      return HistoryViewModel(
        userUseCase,
        ramenUseCase,
        cookHistoryUseCase,
        userId,
        logger,
        ref,
      );
    });