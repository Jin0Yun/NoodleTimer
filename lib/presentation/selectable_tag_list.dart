import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';

class SelectableTagList<T> extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<T> items;
  final String Function(T) labelBuilder;

  const SelectableTagList({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          final label = labelBuilder(items[index]);

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? NoodleColors.primaryLight
                    : NoodleColors.backgroundSearchBar,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: NoodleTextStyles.titleXSmBold.copyWith(
                  color: isSelected
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
