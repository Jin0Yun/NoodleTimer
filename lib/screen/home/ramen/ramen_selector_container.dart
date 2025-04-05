import 'package:flutter/material.dart';
import 'package:noodle_timer/theme/noodle_colors.dart';
import 'package:noodle_timer/theme/noodle_text_styles.dart';
import 'package:noodle_timer/screen/home/ramen/ramen_category_filter.dart';
import 'package:noodle_timer/screen/home/ramen/ramen_card_list.dart';

class RamenSelectorContainer extends StatelessWidget {
  final int selectedCategoryIndex;
  final ValueChanged<int> onCategoryTap;

  final List<String> categories = ['나의 라면 기록', '농심', '삼양', '팔도', '오뚜기', '풀무원'];

  RamenSelectorContainer({
    required this.selectedCategoryIndex,
    required this.onCategoryTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "라면을 선택해주세요!",
            style: NoodleTextStyles.titleSmBold.copyWith(
              color: NoodleColors.textDefault,
            ),
          ),
        ),
        const SizedBox(height: 8),
        RamenCategoryFilter(
          selectedIndex: selectedCategoryIndex,
          categories: categories,
          onTap: onCategoryTap,
        ),
        const SizedBox(height: 12),
        const RamenCardList(itemCount: 3),
      ],
    );
  }
}
