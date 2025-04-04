import 'package:flutter/material.dart';
import 'package:noodle_timer/theme/noodle_colors.dart';
import 'package:noodle_timer/theme/noodle_text_styles.dart';

class RoundedOptionTabContainer extends StatefulWidget {
  const RoundedOptionTabContainer({super.key});

  @override
  State<RoundedOptionTabContainer> createState() =>
      _RoundedOptionTabContainerState();
}

class _RoundedOptionTabContainerState extends State<RoundedOptionTabContainer> {
  String selectedEgg = '계란X';
  String selectedNoodle = '꼬들면';

  final List<_OptionItem> eggOptions = const [
    _OptionItem(label: '계란X', imagePath: 'assets/image/egg_none.png'),
    _OptionItem(label: '반숙', imagePath: 'assets/image/egg_half.png'),
    _OptionItem(label: '완숙', imagePath: 'assets/image/egg_full.png'),
  ];

  final List<_OptionItem> noodleOptions = const [
    _OptionItem(label: '꼬들면', imagePath: 'assets/image/kodul.png'),
    _OptionItem(label: '퍼진면', imagePath: 'assets/image/peojin.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 8),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTab(
            imagePath:
                eggOptions.firstWhere((e) => e.label == selectedEgg).imagePath,
            label: selectedEgg,
            onTap:
                () => _showDialogPicker(
                  context: context,
                  options: eggOptions,
                  currentValue: selectedEgg,
                  onSelected: (value) => setState(() => selectedEgg = value),
                  applyColorToImage: false,
                ),
            applyColorToImage: false,
          ),
          Container(width: 1, height: 36, color: NoodleColors.secondaryGray),
          _buildTab(
            imagePath:
                noodleOptions
                    .firstWhere((e) => e.label == selectedNoodle)
                    .imagePath,
            label: selectedNoodle,
            onTap:
                () => _showDialogPicker(
                  context: context,
                  options: noodleOptions,
                  currentValue: selectedNoodle,
                  onSelected: (value) => setState(() => selectedNoodle = value),
                  applyColorToImage: true,
                ),
            applyColorToImage: true,
          ),
        ],
      ),
    );
  }

  void _showDialogPicker({
    required BuildContext context,
    required List<_OptionItem> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
    bool applyColorToImage = false,
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
                applyColorToImage
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

  Widget _buildTab({
    required String imagePath,
    required String label,
    required VoidCallback onTap,
    required bool applyColorToImage,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 20,
                height: 20,
                color: applyColorToImage ? NoodleColors.primary : null,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: NoodleTextStyles.titleXSmBold.copyWith(
                  color: NoodleColors.primary,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: NoodleColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionItem {
  final String label;
  final String imagePath;
  const _OptionItem({required this.label, required this.imagePath});
}
