import 'package:noodle_timer/presentation/state/base_state.dart';

class TimerState implements BaseState {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final String? ramenName;
  final bool isCompleted;
  final bool _isLoading;
  final String? _error;

  const TimerState({
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isRunning,
    this.ramenName,
    this.isCompleted = false,
    bool isLoading = false,
    String? error,
  }) : _isLoading = isLoading,
       _error = error;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  bool get isInitial => ramenName == null || ramenName!.isEmpty;
  bool get isFinished => isCompleted || remainingSeconds <= 0;

  double get progress {
    if (totalSeconds == 0) return 0.0;
    return 1.0 - (remainingSeconds / totalSeconds);
  }

  TimerState copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    bool? isRunning,
    String? ramenName,
    bool? isCompleted,
    bool? isLoading,
    String? error,
  }) {
    return TimerState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      ramenName: ramenName ?? this.ramenName,
      isCompleted: isCompleted ?? this.isCompleted,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory TimerState.initial() => const TimerState(
    totalSeconds: 0,
    remainingSeconds: 0,
    isRunning: false,
    ramenName: null,
    isCompleted: false,
  );
}