import 'package:flutter/material.dart';
import 'package:noodle_timer/theme/noodle_colors.dart';
import 'package:noodle_timer/theme/noodle_text_styles.dart';

class PreferenceOptionCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PreferenceOptionCard({
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: isSelected ? NoodleColors.primary : NoodleColors.backgroundLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: ColorFiltered(
                  colorFilter: isSelected
                      ? const ColorFilter.mode(NoodleColors.backgroundWhite, BlendMode.dst)
                      : const ColorFilter.mode(NoodleColors.secondaryGray, BlendMode.modulate),
                  child: Image.asset(imagePath, height: 48),
                ),
              ),
              Positioned(
                bottom: 20,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: NoodleTextStyles.titleSm.copyWith(
                    color: isSelected ? NoodleColors.backgroundWhite : NoodleColors.secondaryGray,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
