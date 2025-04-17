import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noodle_timer/app_routes.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/presentation/history/model/history_item.dart';
import 'package:noodle_timer/presentation/history/state/history_state.dart';
import 'package:noodle_timer/presentation/history/widget/recipe_history_card.dart';

class HistoryListView extends ConsumerWidget {
  final RecipeHistoryState state;

  const HistoryListView({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedHistories = _groupHistoriesByDate(state.filteredHistories);
    final sortedDates = groupedHistories.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final historyItems = groupedHistories[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...historyItems.map((item) => RecipeHistoryCard(
              date: date,
              imageUrl: item.imageUrl,
              name: item.name,
              cookedTime:
              '${item.cookTime.inMinutes}분 ${item.cookTime.inSeconds % 60}초 간 조리',
              noodleState: NoodlePreferenceX.from(item.noodleState).displayText,
              eggState: EggPreferenceX.from(item.eggPreference).displayText,
              onCookAgain: () async {
                final viewModel =
                ref.read(recipeHistoryViewModelProvider.notifier);
                await viewModel.cookAgain(item);
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                }
              },
              onDelete: () => ref
                  .read(recipeHistoryViewModelProvider.notifier)
                  .deleteHistory(item.id),
            )),
          ],
        );
      },
    );
  }

  Map<String, List<HistoryItem>> _groupHistoriesByDate(
      List<HistoryItem> histories) {
    final groupedHistories = <String, List<HistoryItem>>{};

    for (var history in histories) {
      final dateStr = DateFormat('yyyy.MM.dd').format(history.cookedAt);
      groupedHistories.putIfAbsent(dateStr, () => []).add(history);
    }

    return groupedHistories;
  }
}
