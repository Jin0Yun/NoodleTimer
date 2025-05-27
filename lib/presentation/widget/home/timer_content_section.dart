import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/state/timer_state.dart';
import 'package:noodle_timer/domain/enum/timer_phase.dart';

class TimerContentSection extends StatelessWidget {
  final TimerState timerState;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onRestart;

  const TimerContentSection({
    required this.timerState,
    this.onStart,
    this.onStop,
    this.onRestart,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (timerState.phase == TimerPhase.initial) {
      return _buildStyledText(
        '라면을 먼저 선택해주세요',
        NoodleTextStyles.titleSmBold.copyWith(color: NoodleColors.primary),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusText(),
          const SizedBox(height: 8),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildStatusText() {
    final ramenName = timerState.ramenName ?? '라면';

    switch (timerState.phase) {
      case TimerPhase.completed:
        return _buildStyledText(
          '조리가 끝났습니다.',
          NoodleTextStyles.titleSmBold.copyWith(
            color: NoodleColors.neutral1000,
          ),
        );
      case TimerPhase.cooking:
        if (timerState.isRunning) {
          return _buildStyledText(
            '$ramenName 조리 중..',
            NoodleTextStyles.titleSm.copyWith(color: NoodleColors.neutral800),
          );
        } else {
          return _buildStyledText(
            ramenName,
            NoodleTextStyles.titleSm.copyWith(color: NoodleColors.neutral800),
          );
        }
      case TimerPhase.initial:
      case TimerPhase.egg:
        return const SizedBox();
    }
  }

  Widget _buildActionButton() {
    switch (timerState.phase) {
      case TimerPhase.completed:
        return _buildActionButtonCommon(
          label: 'RESTART',
          backgroundColor: NoodleColors.neutral100,
          foregroundColor: NoodleColors.neutral700,
          onPressed: onRestart,
        );
      case TimerPhase.cooking:
        return _buildActionButtonCommon(
          label: timerState.isRunning ? 'STOP!' : 'START!',
          backgroundColor:
              timerState.isRunning
                  ? NoodleColors.neutral100
                  : NoodleColors.orange,
          foregroundColor:
              timerState.isRunning
                  ? NoodleColors.accent
                  : NoodleColors.neutral100,
          onPressed: timerState.isRunning ? onStop : onStart,
        );
      case TimerPhase.initial:
      case TimerPhase.egg:
        return const SizedBox();
    }
  }

  Widget _buildActionButtonCommon({
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 1,
      ),
      child: Text(
        label,
        style: NoodleTextStyles.titleSmBold.copyWith(
          color: foregroundColor,
          letterSpacing: 1.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStyledText(String text, TextStyle style) {
    return Text(text, style: style, textAlign: TextAlign.center);
  }
}