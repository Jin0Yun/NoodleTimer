import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const CustomButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: NoodleColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          disabledBackgroundColor: NoodleColors.neutral800.withValues(alpha: 0.2),
        ),
        child: Text(
          buttonText,
          style: NoodleTextStyles.titleSmBold.copyWith(
            color: NoodleColors.neutral100,
          ),
        ),
      ),
    );
  }
}
