class TimerState {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final String? ramenName;
  final bool isTimerMode;
  final bool isCompleted;

  const TimerState({
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isRunning,
    this.ramenName,
    this.isTimerMode = true,
    this.isCompleted = false,
  });

  TimerState copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    bool? isRunning,
    String? ramenName,
    bool? isTimerMode,
    bool? isCompleted,
  }) {
    return TimerState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      ramenName: ramenName ?? this.ramenName,
      isTimerMode: isTimerMode ?? this.isTimerMode,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory TimerState.initial() => const TimerState(
    totalSeconds: 0,
    remainingSeconds: 0,
    isRunning: false,
    ramenName: null,
    isCompleted: false,
  );

  bool get isInitial => ramenName == null || ramenName!.isEmpty;
  bool get isFinished => isCompleted || remainingSeconds <= 0;
  bool get isEggTime => remainingSeconds <= 30 && remainingSeconds > 0 && isRunning;

  double get progress {
    if (totalSeconds == 0) return 0.0;
    return 1.0 - (remainingSeconds / totalSeconds);
  }
}
