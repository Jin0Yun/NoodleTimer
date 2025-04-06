import 'package:flutter/material.dart';
import 'package:noodle_timer/entity/ramen_entity.dart';
import 'package:noodle_timer/theme/noodle_colors.dart';

class RamenCardList extends StatelessWidget {
  final List<RamenEntity> ramens;

  const RamenCardList({
    required this.ramens,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ramens.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final ramen = ramens[index];

          return Container(
            width: 160,
            decoration: BoxDecoration(
              color: NoodleColors.secondaryGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Transform.scale(
                    scale: 0.8,
                    child: Image.network(
                      ramen.imageUrl,
                      fit: BoxFit.cover,
                    )
                )
            ),
          );
        },
      ),
    );
  }
}
