import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class SpicyTag extends StatelessWidget {
  final String label;

  const SpicyTag({super.key, required this.label});

  Color get backgroundColor {
    switch (label) {
      case '매운맛':
        return NoodleColors.spicyHotLight;
      case '중간맛':
        return NoodleColors.spicyMediumLight;
      case '순한맛':
        return NoodleColors.spicyMildLight;
      default:
        return NoodleColors.neutral300;
    }
  }

  Color get textColor {
    switch (label) {
      case '매운맛':
        return NoodleColors.spicyHot;
      case '중간맛':
        return NoodleColors.spicyMedium;
      case '순한맛':
        return NoodleColors.spicyMild;
      default:
        return NoodleColors.neutral800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: NoodleTextStyles.titleXSmBold.copyWith(color: textColor),
      ),
    );
  }
}
