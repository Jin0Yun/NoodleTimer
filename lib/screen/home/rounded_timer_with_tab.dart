import 'package:flutter/material.dart';
import 'package:noodle_timer/screen/home/timer_circle_box.dart';
import 'package:noodle_timer/screen/home/rounded_option_tab_container.dart';

class RoundedTimerWithTab extends StatelessWidget {
  const RoundedTimerWithTab({super.key});

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
          child: RoundedOptionTabContainer(),
        ),
      ],
    );
  }
}
