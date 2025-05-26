import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/presentation/state/history_state.dart';
import 'package:noodle_timer/presentation/widget/card/recipe_history_card.dart';

class HistoryListView extends ConsumerWidget {
  final HistoryState state;

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
                image: history.ramenImageUrl,
                name: history.ramenName,
                cookedTime: history.formattedCookTime,
                noodleState: history.noodleState.displayText,
                eggState: history.eggPreference.displayText,
                onCookAgain: () async {
                  final viewModel = ref.read(historyViewModelProvider.notifier);
                  await viewModel.replayRecipe(history);
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  }
                },
                onDelete: () {
                  ref
                      .read(historyViewModelProvider.notifier)
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