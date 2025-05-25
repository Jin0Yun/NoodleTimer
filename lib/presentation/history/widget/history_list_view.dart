import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/presentation/history/state/history_state.dart';
import 'package:noodle_timer/presentation/history/widget/recipe_history_card.dart';

class HistoryListView extends ConsumerWidget {
  final RecipeHistoryState state;

  const HistoryListView({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedHistories = _groupHistoriesByDate(state.filteredHistories);
    final sortedDates =
        groupedHistories.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final historyItems = groupedHistories[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...historyItems.map(
              (history) => RecipeHistoryCard(
                date: date,
                image: history.ramenImage ?? '',
                name: history.ramenName ?? '알 수 없는 라면',
                cookedTime:
                    '${history.cookTime.inMinutes}분 ${history.cookTime.inSeconds % 60}초 간 조리',
                noodleState: history.noodleState.name,
                eggState: history.eggPreference.name,
                onCookAgain: () async {
                  final viewModel = ref.read(
                    recipeHistoryViewModelProvider.notifier,
                  );
                  await viewModel.replayRecipe(history);
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  }
                },
                onDelete: () {
                  ref
                      .read(recipeHistoryViewModelProvider.notifier)
                      .deleteHistory(history.id);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Map<String, List<CookHistoryEntity>> _groupHistoriesByDate(
    List<CookHistoryEntity> histories,
  ) {
    final groupedHistories = <String, List<CookHistoryEntity>>{};

    for (var history in histories) {
      final dateStr = DateFormat('yyyy.MM.dd').format(history.cookedAt);
      groupedHistories.putIfAbsent(dateStr, () => []).add(history);
    }

    return groupedHistories;
  }
}