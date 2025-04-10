import 'package:flutter/material.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/ramen_card_image.dart';

class RamenCard extends StatelessWidget {
  final RamenEntity ramen;

  const RamenCard({
    required this.ramen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: NoodleColors.neutral400,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: RamenCardImage(imageUrl: ramen.imageUrl)
      ),
    );
  }
}
