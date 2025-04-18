import 'package:flutter/material.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/ramen_card_image.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_action_type.dart';

class RamenCard extends StatelessWidget {
  final RamenEntity ramen;
  final bool isSelected;
  final Function(RamenEntity, RamenActionType) onRamenAction;

  const RamenCard({
    required this.ramen,
    required this.isSelected,
    required this.onRamenAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onRamenAction(ramen, RamenActionType.select),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: NoodleColors.neutral400,
          borderRadius: BorderRadius.circular(8),
          border:
              isSelected
                  ? Border.all(color: NoodleColors.neutral200, width: 3)
                  : null,
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: NoodleColors.primary.withValues(alpha: 0.2),
                      blurRadius: 10,
                    ),
                  ]
                  : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              RamenCardImage(image: ramen.imageUrl),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState:
                    isSelected
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: _buildOverlay(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            NoodleColors.overlay2.withValues(alpha: 0.7),
            NoodleColors.overlay2,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(
              label: "조리하기",
              backgroundColor: NoodleColors.primary,
              textColor: NoodleColors.neutral100,
              onTap: () => onRamenAction(ramen, RamenActionType.cook),
            ),
            const SizedBox(height: 4),
            _buildActionButton(
              label: "라면 상세보기",
              backgroundColor: NoodleColors.primaryLight,
              textColor: NoodleColors.primary,
              onTap: () => onRamenAction(ramen, RamenActionType.detail),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: NoodleTextStyles.titleXSmBold.copyWith(
            color: textColor
          )
        ),
      ),
    );
  }
}
