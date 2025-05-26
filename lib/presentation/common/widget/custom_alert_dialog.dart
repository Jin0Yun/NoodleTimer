import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/custom_dialog_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;
  final bool isSuccess;
  final bool hasCancel;
  final String? cancelText;
  final VoidCallback? onCancel;

  const CustomAlertDialog({
    super.key,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
    this.isSuccess = true,
    this.hasCancel = false,
    this.cancelText,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: NoodleColors.neutral100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: NoodleTextStyles.titleXSmBold.copyWith(
                color: NoodleColors.neutral1000,
              ),
            ),
            const SizedBox(height: 32),
            if (hasCancel)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomDialogButton(
                    text: cancelText ?? '취소',
                    backgroundColor: NoodleColors.neutral200,
                    textColor: NoodleColors.neutral1000,
                    onPressed: onCancel ?? () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 16),
                  CustomDialogButton(
                    text: confirmText,
                    backgroundColor: NoodleColors.primary,
                    textColor: NoodleColors.neutral100,
                    onPressed: onConfirm,
                  ),
                ],
              )
            else
              CustomDialogButton(
                text: confirmText,
                backgroundColor: NoodleColors.primary,
                textColor: NoodleColors.neutral200,
                onPressed: onConfirm,
              ),
          ],
        ),
      ),
    );
  }
}
