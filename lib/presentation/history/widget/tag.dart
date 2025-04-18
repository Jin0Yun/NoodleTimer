import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class Tag extends StatelessWidget {
  final String text;

  const Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: NoodleColors.primary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: NoodleTextStyles.titleSm.copyWith(color: NoodleColors.primary),
      ),
    );
  }
}
