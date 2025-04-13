import 'package:flutter/material.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_provider.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/selectable_tag_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/presentation/home/widget/ramen/ramen_card_list.dart';

class RamenSelectorContainer extends ConsumerWidget {
  final int selectedCategoryIndex;
  final ValueChanged<int> onCategoryTap;

  RamenSelectorContainer({
    required this.selectedCategoryIndex,
    required this.onCategoryTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ramenState = ref.watch(ramenViewModelProvider);
    final ramenBrands = ramenState.brands;
    final selectedBrand = ramenState.brands.isNotEmpty
        ? ramenState.brands[selectedCategoryIndex]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "라면을 선택해주세요!",
            style: NoodleTextStyles.titleSmBold.copyWith(
              color: NoodleColors.neutral1000,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SelectableTagList<RamenBrandEntity>(
          selectedIndex: selectedCategoryIndex,
          onTap: onCategoryTap,
          items: ramenBrands,
          labelBuilder: (brand) => brand.name,
        ),
        const SizedBox(height: 12),
        if (selectedBrand != null)
          RamenCardList(ramens: selectedBrand.ramens),
      ],
    );
  }
}
