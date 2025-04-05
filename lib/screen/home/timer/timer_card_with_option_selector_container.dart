import 'package:flutter/material.dart';
import 'package:noodle_timer/screen/home/option_selector/option_selector_container.dart';
import 'package:noodle_timer/screen/home/timer/timer_circle_box.dart';

class TimerCardWithOptionSelectorContainer extends StatelessWidget {
  const TimerCardWithOptionSelectorContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 8),
                blurRadius: 20,
              ),
            ],
          ),
          child: TimerCircleBox(text: '라면을 먼저 선택해주세요'),
        ),
        Positioned(
          bottom: -10,
          left: 80,
          right: 80,
          child: OptionSelectorContainer(),
        ),
      ],
    );
  }
}
