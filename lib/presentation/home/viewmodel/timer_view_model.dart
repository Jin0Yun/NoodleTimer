import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/home/state/timer_state.dart';

class TimerViewModel extends StateNotifier<TimerState> {
  final AppLogger _logger;
  Timer? _timer;

  TimerViewModel(this._logger) : super(TimerState.initial());

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

    _logger.i('타이머 초기화: $seconds초 ($ramenName)');
  }

  void updateRamen(RamenEntity? ramen) {
    if (ramen == null) return;

    _cancelTimer();
    state = TimerState(
      totalSeconds: ramen.cookTime,
      remainingSeconds: ramen.cookTime,
      isRunning: false,
      ramenName: ramen.name,
      isCompleted: false,
    );

    _logger.i('라면 변경: ${ramen.name} (${ramen.cookTime}초)');
  }

  void start() {
    if (state.remainingSeconds <= 0 || state.isRunning) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        complete();
      }
    });

    state = state.copyWith(isRunning: true, isCompleted: false);
    _logger.i('타이머 시작: ${state.remainingSeconds}초');
  }

  void stop() {
    _cancelTimer();
    state = state.copyWith(isRunning: false);
    _logger.i('타이머 중지됨. 남은 시간: ${state.remainingSeconds}초');
  }

  void complete() {
    _cancelTimer();
    state = state.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      isCompleted: true,
    );
    _logger.i('타이머 완료: 조리가 끝났습니다.');
  }

  void restart() {
    stop();
    state = state.copyWith(
      remainingSeconds: state.totalSeconds,
      isCompleted: false,
    );
    _logger.i('타이머 재시작: ${state.totalSeconds}초');
    start();
  }

  String formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    _logger.i('타이머 해제 및 dispose 완료');
    super.dispose();
  }
}