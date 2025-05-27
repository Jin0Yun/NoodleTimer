import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/domain/enum/egg_preference.dart';
import 'package:noodle_timer/domain/enum/noodle_preference.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/model/option_selector_item.dart';
import 'package:noodle_timer/presentation/widget/home/option_selector_tile.dart';

class OptionSelectorContainer extends ConsumerWidget {
  const OptionSelectorContainer({super.key});

  static const List<OptionSelectorItem> _eggOptions = [
    OptionSelectorItem(label: '계란X', imagePath: 'assets/image/egg_none.png'),
    OptionSelectorItem(label: '반숙', imagePath: 'assets/image/egg_half.png'),
    OptionSelectorItem(label: '완숙', imagePath: 'assets/image/egg_full.png'),
  ];

  static const List<OptionSelectorItem> _noodleOptions = [
    OptionSelectorItem(label: '꼬들면', imagePath: 'assets/image/kodul.png'),
    OptionSelectorItem(label: '퍼진면', imagePath: 'assets/image/peojin.png'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionState = ref.watch(optionViewModelProvider);
    final optionViewModel = ref.read(optionViewModelProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: _containerDecoration(),
      child: Row(
        children: [
          _buildOptionTab(
            context: context,
            options: _eggOptions,
            selectedValue: optionState.eggPreference.displayText,
            applyColor: false,
            onSelected: optionViewModel.updateEggPreferenceFromLabel,
          ),
          _buildDivider(),
          _buildOptionTab(
            context: context,
            options: _noodleOptions,
            selectedValue: optionState.noodlePreference.displayText,
            applyColor: true,
            onSelected: optionViewModel.updateNoodlePreferenceFromLabel,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTab({
    required BuildContext context,
    required List<OptionSelectorItem> options,
    required String selectedValue,
    required bool applyColor,
    required ValueChanged<String> onSelected,
  }) {
    final selectedItem = options.firstWhere(
      (e) => e.label == selectedValue,
      orElse: () => options.first,
    );

    return Expanded(
      child: GestureDetector(
        onTap:
            () => _showOptionPicker(
              context,
              options: options,
              currentValue: selectedValue,
              applyColor: applyColor,
              onSelected: onSelected,
            ),
        child: OptionSelectorTile(
          imagePath: selectedItem.imagePath,
          label: selectedItem.label,
          applyColor: applyColor,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 36, color: NoodleColors.neutral400);
  }

  void _showOptionPicker(
    BuildContext context, {
    required List<OptionSelectorItem> options,
    required String currentValue,
    required bool applyColor,
    required ValueChanged<String> onSelected,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  options.map((option) {
                    final isSelected = option.label == currentValue;
                    return ListTile(
                      leading: Image.asset(
                        option.imagePath,
                        width: 24,
                        height: 24,
                        color:
                            applyColor
                                ? (isSelected
                                    ? NoodleColors.primary
                                    : Colors.grey)
                                : null,
                      ),
                      title: Text(
                        option.label,
                        style: NoodleTextStyles.titleXSmBold.copyWith(
                          color:
                              isSelected
                                  ? NoodleColors.primary
                                  : Colors.black54,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        onSelected(option.label);
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, offset: Offset(0, 8), blurRadius: 12),
      ],
    );
  }
}