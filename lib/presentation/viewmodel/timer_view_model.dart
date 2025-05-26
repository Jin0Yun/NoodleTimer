import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/usecase/cook_history_use_case.dart';
import 'package:noodle_timer/presentation/state/timer_state.dart';
import 'package:noodle_timer/presentation/viewmodel/base_view_model.dart';

class TimerViewModel extends BaseViewModel<TimerState> {
  final CookHistoryUseCase _cookHistoryUseCase;
  final Ref _ref;
  Timer? _timer;
  RamenEntity? _currentRamen;

  TimerViewModel(this._cookHistoryUseCase, AppLogger logger, this._ref)
    : super(logger, TimerState.initial());

  @override
  TimerState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  TimerState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  TimerState clearErrorState() {
    return state.copyWith(error: null);
  }

  void initialize({int? cookingTimeInSeconds, String? ramenName}) {
    _cancelTimer();
    final seconds = cookingTimeInSeconds ?? 0;
    state = TimerState(
      totalSeconds: seconds,
      remainingSeconds: seconds,
      isRunning: false,
      ramenName: ramenName,
      isCompleted: false,
    );
  }

  void updateRamen(RamenEntity? ramen) {
    if (ramen == null) return;
    _currentRamen = ramen;
    _cancelTimer();
    state = TimerState(
      totalSeconds: ramen.cookTime,
      remainingSeconds: ramen.cookTime,
      isRunning: false,
      ramenName: ramen.name,
      isCompleted: false,
    );
  }

  void start() {
    if (state.remainingSeconds <= 0 || state.isRunning) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds > 1) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        complete();
      }
    });
    state = state.copyWith(isRunning: true, isCompleted: false);
  }

  void stop() {
    _cancelTimer();
    state = state.copyWith(isRunning: false);
  }

  Future<void> complete() async {
    _cancelTimer();
    state = state.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      isCompleted: true,
    );

    final ramen = _currentRamen;
    if (ramen == null) {
      return;
    }

    state = setLoadingState(true);
    try {
      await _cookHistoryUseCase.saveCookHistory(ramen);
      await _ref.read(ramenViewModelProvider.notifier).addHistoryRamen(ramen);
      state = setLoadingState(false);
    } catch (e) {
      state = setErrorState(e.toString());
      state = setLoadingState(false);
    }
  }

  void restart() {
    if (state.remainingSeconds <= 0 || state.isRunning) return;
    stop();
    state = state.copyWith(
      remainingSeconds: state.totalSeconds,
      isCompleted: false,
    );
    start();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  static String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
