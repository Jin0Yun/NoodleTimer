import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/home/state/timer_state.dart';
import 'package:noodle_timer/presentation/home/state/timer_phase.dart';

class TimerContentSection extends StatelessWidget {
  final TimerState timerState;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onRestart;

  TimerContentSection({
    required this.timerState,
    this.onStart,
    this.onStop,
    this.onRestart,
    Key? key,
  }) : super(key: key);

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
    final Map<TimerPhase, Widget Function()> builders = {
      TimerPhase.egg: () => _buildStyledText(
        '계란을 넣어주세요!',
        NoodleTextStyles.titleSmBold.copyWith(color: NoodleColors.primary),
      ),
      TimerPhase.completed: () => _buildStyledText(
        '조리가 끝났습니다.',
        NoodleTextStyles.titleSmBold.copyWith(
          color: NoodleColors.neutral1000,
        ),
      ),
      TimerPhase.cooking: () => _buildStyledText(
        timerState.ramenName!,
        NoodleTextStyles.titleSm.copyWith(color: NoodleColors.neutral800),
      ),
    };

    return builders[timerState.phase]?.call() ?? const SizedBox();
  }

  Widget _buildStyledText(String text, TextStyle style) {
    return Text(text, style: style, textAlign: TextAlign.center);
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
        final isRunning = timerState.isRunning;
        return _buildActionButtonCommon(
          label: isRunning ? 'STOP!' : 'START!',
          backgroundColor:
          isRunning ? NoodleColors.neutral100 : NoodleColors.orange,
          foregroundColor:
          isRunning ? NoodleColors.accent : NoodleColors.neutral100,
          onPressed: isRunning ? onStop : onStart,
        );
      default:
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
      child: _buildStyledText(
        label,
        NoodleTextStyles.titleSmBold.copyWith(
          color: foregroundColor,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}