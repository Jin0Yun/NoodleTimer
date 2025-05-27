import 'package:flutter/material.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/state/ramen_state.dart';
import 'package:noodle_timer/presentation/widget/card/ramen_search_result_card.dart';

class RamenList extends StatelessWidget {
  final RamenState state;
  final void Function(BuildContext context, RamenEntity ramen)? onTap;

  const RamenList({required this.state, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final ramens = state.isSearching ? state.searchResults : state.allRamen;

    if (ramens.isEmpty) {
      return Center(
        child: Text(
          state.isSearching ? '검색 결과가 없습니다.' : '표시할 라면이 없습니다.',
          style: NoodleTextStyles.titleMd.copyWith(
            color: NoodleColors.neutral800,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: ramens.length,
      itemBuilder: (context, index) {
        final ramen = ramens[index];
        return RamenSearchResultCard(
          key: Key('ramen_${ramen.id}'),
          ramen: ramen,
          onTap: (selected) => onTap?.call(context, selected),
        );
      },
    );
  }
}