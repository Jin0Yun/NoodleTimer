import 'package:flutter/material.dart';
import 'package:noodle_timer/theme/noodle_colors.dart';
import 'package:noodle_timer/theme/noodle_text_styles.dart';

class TimerCircleBox extends StatelessWidget {
  final String text;
  const TimerCircleBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: NoodleColors.primary, width: 10),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: NoodleTextStyles.titleSmBold.copyWith(
            color: NoodleColors.primary,
          ),
        ),
      ),
    );
  }
}
