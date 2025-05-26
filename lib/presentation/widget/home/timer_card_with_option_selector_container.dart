import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/widget/home/option_selector_container.dart';
import 'package:noodle_timer/presentation/widget/home/timer_circle_box.dart';
import 'package:noodle_timer/presentation/viewmodel/ramen_state.dart';

class TimerCardWithOptionSelectorContainer extends ConsumerWidget {
  final RamenEntity? selectedRamen;
  final int? cookingTimeInSeconds;

  const TimerCardWithOptionSelectorContainer({
    this.selectedRamen,
    this.cookingTimeInSeconds,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<RamenState>(ramenViewModelProvider, (previous, next) {
      if (previous?.selectedRamen?.id != next.selectedRamen?.id &&
          next.selectedRamen != null) {
        ref
            .read(timerViewModelProvider.notifier)
            .updateRamen(next.selectedRamen!);
      }
    });

    return Stack(
      clipBehavior: Clip.none,
      children: [_buildTimerCard(context, ref), _buildOptionSelector()],
    );
  }

  Widget _buildTimerCard(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerViewModelProvider);
    final timerViewModel = ref.read(timerViewModelProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      padding: const EdgeInsets.all(32),
      decoration: _buildCardDecoration(),
      child: TimerCircleBox(
        timerState: timerState,
        onStart: timerViewModel.start,
        onStop: timerViewModel.stop,
        onRestart: timerViewModel.restart,
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: NoodleColors.neutral100,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: NoodleColors.neutral700,
          offset: Offset(0, 8),
          blurRadius: 20,
        ),
      ],
    );
  }

  Widget _buildOptionSelector() {
    return const Positioned(
      bottom: -10,
      left: 80,
      right: 80,
      child: OptionSelectorContainer(),
    );
  }
}