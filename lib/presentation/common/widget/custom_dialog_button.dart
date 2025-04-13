import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class CustomDialogButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const CustomDialogButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 38,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: NoodleTextStyles.titleXSmBold,
        ),
      ),
    );
  }
}
