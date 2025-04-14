import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class TextButtonWithAction extends StatelessWidget {
  final String title;
  final Color textColor;
  final VoidCallback onTap;

  const TextButtonWithAction({
    required this.title,
    required this.textColor,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: NoodleTextStyles.titleSm.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
