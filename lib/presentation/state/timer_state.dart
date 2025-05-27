import 'package:noodle_timer/domain/enum/timer_phase.dart';
import 'package:noodle_timer/presentation/state/base_state.dart';

class TimerState implements BaseState {
  final TimerPhase phase;
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final String? ramenName;
  final bool _isLoading;
  final String? _error;

  const TimerState({
    required this.phase,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isRunning,
    this.ramenName,
    bool isLoading = false,
    String? error,
  }) : _isLoading = isLoading,
       _error = error;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  double get progress {
    if (totalSeconds == 0) return 0.0;
    return 1.0 - (remainingSeconds / totalSeconds);
  }

  TimerState copyWith({
    TimerPhase? phase,
    int? totalSeconds,
    int? remainingSeconds,
    bool? isRunning,
    String? ramenName,
    bool? isLoading,
    String? error,
  }) {
    return TimerState(
      phase: phase ?? this.phase,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      ramenName: ramenName ?? this.ramenName,
      isLoading: isLoading ?? _isLoading,
      error: error,
    );
  }

  factory TimerState.initial() => const TimerState(
    phase: TimerPhase.initial,
    totalSeconds: 0,
    remainingSeconds: 0,
    isRunning: false,
  );
}