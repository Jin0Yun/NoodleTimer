import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class CustomRoundedHeader extends StatelessWidget {
  const CustomRoundedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: NoodleColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/app_icon.png',
                  width: 33,
                  height: 33,
                ),
                SizedBox(width: 6),
                Text(
                  "K-라면타이머",
                  style: NoodleTextStyles.titleSmBold.copyWith(
                    color: NoodleColors.backgroundWhite,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                GestureDetector(
                  onTap: (){},
                  child: const Icon(
                    Icons.person_outline,
                    size: 25,
                    color: NoodleColors.backgroundWhite,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.settings_outlined,
                    size: 25,
                    color: NoodleColors.backgroundWhite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
