import 'package:flutter/material.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/search/state/search_state.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/search/widget/ramen_search_result_card.dart';

class RamenList extends StatelessWidget {
  final SearchState state;
  final void Function(BuildContext context, RamenEntity ramen)? onTap;

  const RamenList({
    required this.state,
    this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final ramens = state.hasKeyword ? state.searchResults : state.allRamen;

    if (ramens.isEmpty) {
      return Center(
        child: Text(
          '표시할 라면이 없습니다.',
          style: NoodleTextStyles.titleMd.copyWith(
            color: NoodleColors.neutral800,
          )
        ),
      );
    }

    return ListView.builder(
      itemCount: ramens.length,
      itemBuilder: (context, index) {
        final ramen = ramens[index];
        return RamenSearchResultCard(
          ramen: ramen,
          onTap: (selected) => onTap?.call(context, selected)
        );
      },
    );
  }
}