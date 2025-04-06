import 'package:flutter/material.dart';
import 'package:noodle_timer/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/theme/noodle_colors.dart';
import 'package:noodle_timer/theme/noodle_text_styles.dart';

class RamenCategoryFilter extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<RamenBrandEntity> ramenBrands;

  const RamenCategoryFilter({
    required this.selectedIndex,
    required this.onTap,
    required this.ramenBrands,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ramenBrands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color:
                isSelected
                    ? NoodleColors.primaryLight
                    : NoodleColors.secondaryGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ramenBrands[index].name,
                style: NoodleTextStyles.titleXSmBold.copyWith(
                  color:
                  isSelected
                      ? NoodleColors.primary
                      : NoodleColors.categoryTabText,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
