import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/history/widget/history_list_view.dart';

class HistoryBody extends ConsumerWidget {
  const HistoryBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyViewModelProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.filteredHistories.isEmpty) {
      return const Center(child: Text('조리 내역이 없습니다.'));
    }

    return HistoryListView(state: state);
  }
}