import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'package:noodle_timer/presentation/home/state/timer_state.dart';

class TimerViewModel extends StateNotifier<TimerState> {
  final UserRepository _userRepository;
  final AppLogger _logger;
  final Ref _ref;
  Timer? _timer;
  RamenEntity? _currentRamen;

  TimerViewModel(this._userRepository, this._logger, this._ref)
      : super(TimerState.initial());

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
    _logger.i('타이머 초기화 완료: $seconds초 (${ramenName ?? "이름 없음"})');
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
    _logger.i('타이머 시작됨: ${state.remainingSeconds}초');
  }

  void stop() {
    _cancelTimer();
    state = state.copyWith(isRunning: false);
    _logger.d('타이머 중지됨. 남은 시간: ${state.remainingSeconds}초');
  }

  Future<void> complete() async {
    _cancelTimer();
    state = state.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      isCompleted: true,
    );
    _logger.i('타이머 완료 - 조리 완료됨');

    final ramen = _currentRamen;
    if (ramen == null) {
      _logger.w('조리 기록 저장 실패: 라면 정보 없음');
      return;
    }

    final userId = _userRepository.getCurrentUserId();
    if (userId == null) {
      _logger.w('조리 기록 저장 실패: 유저 정보 없음');
      return;
    }

    final history = CookHistoryEntity(
      ramenId: ramen.id.toString(),
      cookedAt: DateTime.now(),
      noodleState: NoodlePreference.kodul,
      eggPreference: EggPreference.none,
      cookTime: Duration(seconds: ramen.cookTime),
    );

    try {
      await _userRepository.saveCookHistory(userId, history);
      _logger.i('조리 기록 저장 완료: ${ramen.name}');
      await _ref.read(ramenViewModelProvider.notifier).loadBrands();
      _logger.i('라면 브랜드 목록 새로고침 완료');
    } catch (e, st) {
      _logger.e('조리 기록 저장 실패', e, st);
    }
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

  void _cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  static String formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _cancelTimer();
    _logger.d('TimerViewModel dispose 완료');
    super.dispose();
  }
}