import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/home/widget/option_selector/option_selector_item.dart';
import 'package:noodle_timer/presentation/home/widget/option_selector/option_selector_tile.dart';

class OptionSelectorContainer extends StatefulWidget {
  const OptionSelectorContainer({super.key});

  @override
  State<OptionSelectorContainer> createState() => _OptionSelectorContainerState();
}

class _OptionSelectorContainerState extends State<OptionSelectorContainer> {
  String selectedEgg = '계란X';
  String selectedNoodle = '꼬들면';

  final List<OptionSelectorItem> _eggOptions = const [
    OptionSelectorItem(label: '계란X', imagePath: 'assets/image/egg_none.png'),
    OptionSelectorItem(label: '반숙', imagePath: 'assets/image/egg_half.png'),
    OptionSelectorItem(label: '완숙', imagePath: 'assets/image/egg_full.png'),
  ];

  final List<OptionSelectorItem> _noodleOptions = const [
    OptionSelectorItem(label: '꼬들면', imagePath: 'assets/image/kodul.png'),
    OptionSelectorItem(label: '퍼진면', imagePath: 'assets/image/peojin.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: _containerDecoration(),
      child: Row(
        children: [
          _buildOptionTab(
            options: _eggOptions,
            selectedValue: selectedEgg,
            applyColor: false,
            onSelected: (value) => setState(() => selectedEgg = value),
          ),
          _buildDivider(),
          _buildOptionTab(
            options: _noodleOptions,
            selectedValue: selectedNoodle,
            applyColor: true,
            onSelected: (value) => setState(() => selectedNoodle = value),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTab({
    required List<OptionSelectorItem> options,
    required String selectedValue,
    required bool applyColor,
    required ValueChanged<String> onSelected,
  }) {
    final selectedItem = options.firstWhere((e) => e.label == selectedValue);

    return Expanded(
      child: GestureDetector(
        onTap: () => _showOptionPicker(
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
    return Container(
      width: 1,
      height: 36,
      color: NoodleColors.neutral400,
    );
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
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final isSelected = option.label == currentValue;
            return ListTile(
              leading: Image.asset(
                option.imagePath,
                width: 24,
                height: 24,
                color: applyColor
                    ? (isSelected ? NoodleColors.primary : Colors.grey)
                    : null,
              ),
              title: Text(
                option.label,
                style: NoodleTextStyles.titleXSmBold.copyWith(
                  color: isSelected ? NoodleColors.primary : Colors.black54,
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
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 8),
          blurRadius: 12,
        ),
      ],
    );
  }
}
