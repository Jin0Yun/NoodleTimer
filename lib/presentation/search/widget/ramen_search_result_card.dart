import 'package:flutter/material.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/ramen_card_image.dart';

class RamenSearchResultCard extends StatelessWidget {
  final RamenEntity ramen;
  final Function(RamenEntity) onTap;

  const RamenSearchResultCard({
    required this.ramen,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(ramen),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: NoodleColors.neutral100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: NoodleColors.neutral400,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        RamenCardImage(
          image: ramen.imageUrl,
          width: 70,
          height: 70,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ramen.name,
                style: NoodleTextStyles.titleXSmBold.copyWith(
                  color: NoodleColors.neutral1000,
                )
              ),
              const SizedBox(height: 4),
              Text(
                ramen.description,
                style: NoodleTextStyles.titleSm.copyWith(
                  color: NoodleColors.neutral800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}