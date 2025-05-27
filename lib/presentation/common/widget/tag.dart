import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

enum TagType { spicy, normal }

class Tag extends StatelessWidget {
  final String text;
  final TagType type;

  const Tag({
    super.key,
    required this.text,
    this.type = TagType.normal,
  });

  const Tag.spicy({
    super.key,
    required this.text,
  }) : type = TagType.spicy;

  Color get backgroundColor {
    if (type == TagType.spicy) {
      switch (text) {
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
    return Colors.transparent;
  }

  Color get textColor {
    if (type == TagType.spicy) {
      switch (text) {
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
    return NoodleColors.primary;
  }

  Border? get border {
    return type == TagType.normal ? Border.all(color: NoodleColors.primary) : null;
  }

  EdgeInsets get padding {
    return type == TagType.spicy
        ? const EdgeInsets.symmetric(horizontal: 12)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  }

  double? get height {
    return type == TagType.spicy ? 28 : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      alignment: type == TagType.spicy ? Alignment.center : null,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: BorderRadius.circular(type == TagType.spicy ? 8 : 20),
      ),
      child: Text(
        text,
        style: type == TagType.spicy
            ? NoodleTextStyles.titleXSmBold.copyWith(color: textColor)
            : NoodleTextStyles.titleSm.copyWith(color: textColor),
      ),
    );
  }
}