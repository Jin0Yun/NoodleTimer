import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/presentation/state/timer_state.dart';
import 'package:noodle_timer/domain/enum/timer_phase.dart';
import 'package:noodle_timer/presentation/widget/home/timer_content_section.dart';
import 'package:noodle_timer/presentation/widget/home/timer_display.dart';
import 'package:noodle_timer/presentation/widget/home/timer_progress_indicator.dart';

class TimerCircleBox extends ConsumerWidget {
  final TimerState timerState;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onRestart;

  const TimerCircleBox({
    required this.timerState,
    this.onStart,
    this.onStop,
    this.onRestart,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TimerProgressIndicator(
            phase: timerState.phase,
            progress: timerState.progress,
          ),
          TimerContentSection(
            timerState: timerState,
            onStart: onStart,
            onStop: onStop,
            onRestart: onRestart,
          ),
          if (timerState.phase != TimerPhase.initial)
            Positioned(
              bottom: 20,
              child: TimerDisplay(),
            ),
        ],
      ),
    );
  }
}