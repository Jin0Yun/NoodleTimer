import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/home/state/timer_state.dart';

class TimerCircleBox extends StatelessWidget {
  final TimerState timerState;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onRestart;

  const TimerCircleBox({
    required this.timerState,
    this.onStart,
    this.onStop,
    this.onRestart,
    super.key
  });

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final sec = seconds % 60;
    return '$minutes:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildProgressIndicators(),
          _buildCenterContent(),
          if (!timerState.isInitial) _buildTimerText(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicators() {
    if (timerState.isInitial) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CircularProgressIndicator(
          value: 1.0,
          strokeWidth: 10,
          backgroundColor: NoodleColors.transparent,
          color: NoodleColors.primary,
        ),
      );
    } else {
      return Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 10,
              backgroundColor: NoodleColors.transparent,
              color: NoodleColors.primaryLight,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CircularProgressIndicator(
              value: _getProgressValue(),
              strokeWidth: 10,
              backgroundColor: NoodleColors.transparent,
              color: NoodleColors.primary,
            ),
          ),
        ],
      );
    }
  }

  double _getProgressValue() {
    if (timerState.isRunning || timerState.isFinished) {
      return 1.0 - (timerState.remainingSeconds / timerState.totalSeconds);
    }
    return 0.0;
  }

  Widget _buildCenterContent() {
    if (timerState.isInitial) {
      return Center(
        child: Text(
          '라면을 먼저 선택해주세요',
          style: NoodleTextStyles.titleSmBold.copyWith(
            color: NoodleColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
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
  }

  Widget _buildStatusText() {
    if (timerState.isEggTime) {
      return Text(
        '계란을 넣어주세요!',
        style: NoodleTextStyles.titleSmBold.copyWith(
          color: NoodleColors.primary,
        ),
      );
    } else if (timerState.isCompleted) {
      return Text(
        '조리가 끝났습니다.',
        style: NoodleTextStyles.titleSmBold.copyWith(
          color: NoodleColors.neutral1000,
        ),
      );
    } else {
      return Text(
        timerState.ramenName!,
        style: NoodleTextStyles.titleSm.copyWith(
          color: NoodleColors.neutral800,
        ),
      );
    }
  }

  Widget _buildActionButton() {
    if (timerState.isCompleted) {
      return _buildRestartButton();
    } else if (!timerState.isEggTime) {
      return _buildStartStopButton();
    } else {
      return const SizedBox();
    }
  }

  Widget _buildRestartButton() {
    return ElevatedButton(
      onPressed: onRestart,
      style: ElevatedButton.styleFrom(
        backgroundColor: NoodleColors.neutral100,
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Text(
        '다시시작',
        style: NoodleTextStyles.titleSmBold.copyWith(
          color: NoodleColors.neutral900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildStartStopButton() {
    return ElevatedButton(
      onPressed: timerState.isRunning ? onStop : onStart,
      style: ElevatedButton.styleFrom(
        backgroundColor: timerState.isRunning
            ? NoodleColors.neutral100
            : NoodleColors.orange,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Text(
        timerState.isRunning ? 'STOP!' : 'START!',
        style: NoodleTextStyles.titleSmBold.copyWith(
          color: timerState.isRunning
              ? NoodleColors.accent
              : NoodleColors.neutral100,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildTimerText() {
    return Positioned(
      bottom: 20,
      child: Text(
        _formatTime(timerState.remainingSeconds),
        style: NoodleTextStyles.titleMdBold.copyWith(
          color: NoodleColors.neutral800,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}