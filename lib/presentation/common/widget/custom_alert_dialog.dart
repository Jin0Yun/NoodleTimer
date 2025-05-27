import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/custom_dialog_button.dart';
import 'package:noodle_timer/presentation/common/widget/custom_text_field.dart';

class CustomAlertDialog extends StatefulWidget {
  final String message;
  final String confirmText;
  final VoidCallback? onConfirm;
  final bool isSuccess;
  final bool hasCancel;
  final String? cancelText;
  final VoidCallback? onCancel;
  final bool needsPassword;
  final Function(String)? onPasswordConfirm;

  const CustomAlertDialog({
    super.key,
    required this.message,
    required this.confirmText,
    this.onConfirm,
    this.isSuccess = true,
    this.hasCancel = false,
    this.cancelText,
    this.onCancel,
    this.needsPassword = false,
    this.onPasswordConfirm,
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

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
              widget.message,
              textAlign: TextAlign.center,
              style: NoodleTextStyles.titleXSmBold.copyWith(
                color: NoodleColors.neutral1000,
              ),
            ),
            if (widget.needsPassword) ...[
              const SizedBox(height: 24),
              CustomTextField(
                hint: '비밀번호를 입력하세요',
                controller: _passwordController,
                obscureText: _obscurePassword,
                isCompact: true,
                isPassword: true,
                onToggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ],
            const SizedBox(height: 32),
            if (widget.hasCancel)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomDialogButton(
                    text: widget.cancelText ?? '취소',
                    backgroundColor: NoodleColors.neutral200,
                    textColor: NoodleColors.neutral1000,
                    onPressed:
                        widget.onCancel ?? () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 16),
                  CustomDialogButton(
                    text: widget.confirmText,
                    backgroundColor: NoodleColors.primary,
                    textColor: NoodleColors.neutral100,
                    onPressed: () {
                      if (widget.needsPassword) {
                        widget.onPasswordConfirm?.call(
                          _passwordController.text,
                        );
                      } else {
                        widget.onConfirm?.call();
                      }
                    },
                  ),
                ],
              )
            else
              CustomDialogButton(
                text: widget.confirmText,
                backgroundColor: NoodleColors.primary,
                textColor: NoodleColors.neutral200,
                onPressed: () {
                  if (widget.needsPassword) {
                    widget.onPasswordConfirm?.call(_passwordController.text);
                  } else {
                    widget.onConfirm?.call();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}