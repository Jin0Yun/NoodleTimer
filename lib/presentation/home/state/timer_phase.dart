import 'package:noodle_timer/presentation/home/state/timer_state.dart';

enum TimerPhase {
  initial,
  cooking,
  egg,
  completed,
}

extension TimerPhaseResolver on TimerState {
  TimerPhase get phase {
    if (isInitial) return TimerPhase.initial;
    if (isEggTime) return TimerPhase.egg;
    if (isCompleted) return TimerPhase.completed;
    return TimerPhase.cooking;
  }
}
