import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/selectable_tag_list.dart';
import 'package:noodle_timer/presentation/home/widget/ramen/ramen_card_list.dart';

class RamenSelectorContainer extends ConsumerWidget {
  const RamenSelectorContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ramenViewModel = ref.read(ramenViewModelProvider.notifier);
    final ramenState = ref.watch(ramenViewModelProvider);
    final brands = ramenState.brands;
    final ramens = ramenState.currentRamenList;
    final selectedBrandIndex = ramenState.selectedBrandIndex;

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
        SelectableTagList(
          selectedIndex: selectedBrandIndex,
          onTap: (index) => ramenViewModel.selectBrand(index),
          items: brands,
          labelBuilder: (brand) => brand.name,
        ),
        const SizedBox(height: 12),
        RamenCardList(ramens: ramens),
      ],
    );
  }
}
