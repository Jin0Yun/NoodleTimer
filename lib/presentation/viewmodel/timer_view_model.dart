import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'package:noodle_timer/presentation/state/timer_state.dart';
import 'package:noodle_timer/presentation/viewmodel/base_view_model.dart';

class TimerViewModel extends BaseViewModel<TimerState> {
  final UserRepository _userRepository;
  final Ref _ref;
  Timer? _timer;
  RamenEntity? _currentRamen;

  TimerViewModel(this._userRepository, AppLogger logger, this._ref)
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
    logger.i('타이머 초기화 완료: $seconds초 (${ramenName ?? "이름 없음"})');
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
    logger.i('타이머 시작됨: ${state.remainingSeconds}초');
  }

  void stop() {
    _cancelTimer();
    state = state.copyWith(isRunning: false);
    logger.d('타이머 중지됨. 남은 시간: ${state.remainingSeconds}초');
  }

  Future<void> complete() async {
    _cancelTimer();
    state = state.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      isCompleted: true,
    );
    logger.i('타이머 완료 - 조리 완료됨');

    final ramen = _currentRamen;
    if (ramen == null) {
      logger.w('조리 기록 저장 실패: 라면 정보 없음');
      return;
    }

    await runWithLoading(() async {
      final userId = _userRepository.getCurrentUserId();
      if (userId == null) {
        throw Exception('조리 기록 저장 실패: 유저 정보 없음');
      }

      final history = CookHistoryEntity(
        ramenId: ramen.id.toString(),
        cookedAt: DateTime.now(),
        noodleState: NoodlePreference.kodul,
        eggPreference: EggPreference.none,
        cookTime: Duration(seconds: ramen.cookTime),
      );

      await _userRepository.saveCookHistory(userId, history);
      logger.i('조리 기록 저장 완료: ${ramen.name}');
      await _ref.read(ramenViewModelProvider.notifier).loadBrands();
      logger.i('라면 브랜드 목록 새로고침 완료');
    }, showLoading: false);
  }

  void restart() {
    stop();
    state = state.copyWith(
      remainingSeconds: state.totalSeconds,
      isCompleted: false,
    );
    logger.i('타이머 재시작: ${state.totalSeconds}초');
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
    logger.d('TimerViewModel dispose 완료');
    super.dispose();
  }
}