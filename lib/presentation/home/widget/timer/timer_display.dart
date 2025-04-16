import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/home/state/timer_state.dart';

class TimerDisplay extends ConsumerWidget {
  final TimerState timerState;

  const TimerDisplay({
    required this.timerState,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerViewModel = ref.read(timerViewModelProvider.notifier);

    return Text(
      timerViewModel.formatTime(timerState.remainingSeconds),
      style: NoodleTextStyles.titleMdBold.copyWith(
        color: NoodleColors.neutral800,
        letterSpacing: 1.0,
      ),
    );
  }
}