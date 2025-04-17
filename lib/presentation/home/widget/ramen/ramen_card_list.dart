import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/home/widget/ramen/ramen_card.dart';

class RamenCardList extends ConsumerWidget {
  final List<RamenEntity> ramens;

  const RamenCardList({required this.ramens, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ramenState = ref.watch(ramenViewModelProvider);
    final selectedRamenId = ramenState.selectedRamenId;
    final viewModel = ref.read(ramenViewModelProvider.notifier);

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
            isSelected: selectedRamenId == ramen.id,
            onRamenAction: viewModel.handleRamenAction,
          );
        },
      ),
    );
  }
}