import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final String? errorMessage;
  final void Function(String)? onChanged;
  final bool isCompact;
  final bool isPassword;
  final VoidCallback? onToggleVisibility;

  const CustomTextField({
    super.key,
    this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.errorMessage,
    this.onChanged,
    this.isCompact = false,
    this.isPassword = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label ?? '',
            style: NoodleTextStyles.titleXSmBold.copyWith(
              color: NoodleColors.neutral1000,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: NoodleColors.neutral200,
            hintStyle: const TextStyle(color: NoodleColors.neutral800),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isCompact ? 8 : 10,
            ),
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: NoodleColors.neutral600,
                      ),
                      onPressed: onToggleVisibility,
                    )
                    : (hasError
                        ? const Icon(Icons.error, color: NoodleColors.error)
                        : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? NoodleColors.error : NoodleColors.neutral700,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? NoodleColors.error : NoodleColors.neutral700,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? NoodleColors.error : NoodleColors.neutral700,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (hasError && errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4),
            child: Text(
              errorMessage ?? '',
              style: NoodleTextStyles.titleXsm.copyWith(
                color: NoodleColors.error,
              ),
            ),
          ),
      ],
    );
  }
}