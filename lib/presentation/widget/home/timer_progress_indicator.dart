import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/domain/enum/timer_phase.dart';

class TimerProgressIndicator extends StatelessWidget {
  final TimerPhase phase;
  final double progress;

  const TimerProgressIndicator({
    required this.phase,
    required this.progress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (phase == TimerPhase.initial) {
      return _buildFullCircleProgress(value: 1.0, color: NoodleColors.primary);
    }

    return Stack(
      children: [
        _buildFullCircleProgress(value: 1.0, color: NoodleColors.primaryLight),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: progress, end: progress),
          duration: const Duration(milliseconds: 1000),
          builder: (context, value, _) {
            return _buildFullCircleProgress(
              value: value,
              color: NoodleColors.primary,
            );
          },
        ),
      ],
    );
  }

  Widget _buildFullCircleProgress({
    required double value,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: 10,
        backgroundColor: NoodleColors.transparent,
        color: color,
      ),
    );
  }
}