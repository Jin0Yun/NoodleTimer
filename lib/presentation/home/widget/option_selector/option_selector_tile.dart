import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class OptionSelectorTile extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool applyColor;

  const OptionSelectorTile({
    super.key,
    required this.imagePath,
    required this.label,
    required this.applyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 20,
            height: 20,
            color: applyColor ? NoodleColors.primary : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: NoodleTextStyles.titleXSmBold.copyWith(
              color: NoodleColors.textDefault,
            ),
          ),
        ],
      ),
    );
  }
}
