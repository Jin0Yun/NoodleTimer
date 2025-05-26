import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/viewmodel/timer_view_model.dart';

class TimerDisplay extends ConsumerWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerViewModelProvider);

    return Text(
      TimerViewModel.formatTime(timerState.remainingSeconds),
      style: NoodleTextStyles.titleMdBold.copyWith(
        color: NoodleColors.neutral800,
        letterSpacing: 1.0,
      ),
    );
  }
}