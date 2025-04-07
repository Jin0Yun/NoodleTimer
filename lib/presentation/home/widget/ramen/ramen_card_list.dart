import 'package:flutter/material.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/home/widget/ramen/ramen_card.dart';

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
          return RamenCard(
            key: ValueKey(ramen.id),
            ramen: ramen,
          );
        },
      ),
    );
  }
}