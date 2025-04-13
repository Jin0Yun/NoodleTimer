import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
    this.onClear,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final showClear = controller.text.isNotEmpty;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: NoodleColors.neutral300,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NoodleColors.neutral500),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(color: NoodleColors.neutral800),
              ),
            ),
          ),
          if (showClear && onClear != null)
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close, size: 16, color: NoodleColors.neutral100),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              style: IconButton.styleFrom(
                backgroundColor: NoodleColors.neutral600,
                shape: const CircleBorder(),
              ),
            ),
        ],
      ),
    );
  }
}
