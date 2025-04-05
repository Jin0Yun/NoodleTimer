import 'package:flutter/material.dart';
import 'package:noodle_timer/theme/noodle_colors.dart';

class RamenCardList extends StatelessWidget {
  final int itemCount;
  const RamenCardList({required this.itemCount, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            decoration: BoxDecoration(
              color: NoodleColors.secondaryGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
