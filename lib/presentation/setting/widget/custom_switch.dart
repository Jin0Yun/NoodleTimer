import 'package:flutter/cupertino.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class CustomSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: NoodleTextStyles.titleSm),
        CupertinoSwitch(
          activeTrackColor: NoodleColors.primary,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
