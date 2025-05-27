import 'dart:async';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/enum/egg_preference.dart';
import 'package:noodle_timer/domain/enum/noodle_preference.dart';
import 'package:noodle_timer/domain/usecase/cook_history_use_case.dart';
import 'package:noodle_timer/presentation/state/timer_state.dart';
import 'package:noodle_timer/presentation/viewmodel/base_view_model.dart';
import 'package:noodle_timer/domain/enum/timer_phase.dart';

class TimerViewModel extends BaseViewModel<TimerState> {
  final CookHistoryUseCase _cookHistoryUseCase;
  Timer? _timer;
  RamenEntity? _currentRamen;
  EggPreference _eggPreference = EggPreference.none;
  NoodlePreference _noodlePreference = NoodlePreference.kodul;

  TimerViewModel(this._cookHistoryUseCase, AppLogger logger)
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

  void updateRamen(RamenEntity ramen) {
    _currentRamen = ramen;
    _cancelTimer();

    state = TimerState(
      phase: TimerPhase.cooking,
      totalSeconds: ramen.cookTime,
      remainingSeconds: ramen.cookTime,
      ramenName: ramen.name,
      isRunning: false,
    );
  }

  void updatePreferences(
    EggPreference eggPreference,
    NoodlePreference noodlePreference,
  ) {
    _eggPreference = eggPreference;
    _noodlePreference = noodlePreference;
  }

  void start() {
    if (state.remainingSeconds <= 0 ||
        state.isRunning ||
        state.phase == TimerPhase.initial) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final newRemaining = state.remainingSeconds - 1;

      if (newRemaining <= 0) {
        _completeTimer();
        return;
      }

      state = state.copyWith(remainingSeconds: newRemaining);
    });

    state = state.copyWith(isRunning: true);
  }

  void stop() {
    _cancelTimer();
    state = state.copyWith(isRunning: false);
  }

  void restart() {
    _cancelTimer();
    if (_currentRamen != null) {
      updateRamen(_currentRamen!);
    }
  }

  Future<void> _completeTimer() async {
    _cancelTimer();
    state = state.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      phase: TimerPhase.completed,
    );

    if (_currentRamen != null) {
      await _saveCookHistoryWithOptions();
    }
  }

  Future<void> _saveCookHistoryWithOptions() async {
    if (_currentRamen == null) return;

    await runWithLoading(() async {
      await _cookHistoryUseCase.saveCookHistoryWithPreferences(
        _currentRamen!,
        _noodlePreference,
        _eggPreference,
        Duration(seconds: state.totalSeconds),
      );
    });
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