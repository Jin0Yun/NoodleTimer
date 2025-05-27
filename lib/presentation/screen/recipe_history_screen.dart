import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/widget/custom_app_bar.dart';
import 'package:noodle_timer/presentation/common/widget/searchable_widget.dart';
import 'package:noodle_timer/presentation/widget/history/history_body.dart';
import 'package:noodle_timer/presentation/state/history_state.dart';

class RecipeHistoryScreen extends ConsumerStatefulWidget {
  const RecipeHistoryScreen({super.key});

  @override
  ConsumerState<RecipeHistoryScreen> createState() =>
      _RecipeHistoryScreenState();
}

class _RecipeHistoryScreenState extends ConsumerState<RecipeHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyViewModelProvider.notifier).loadCookHistories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyNotifier = ref.read(historyViewModelProvider.notifier);

    ref.listen<HistoryState>(historyViewModelProvider, (previous, next) {
      if (previous?.historyDeleted == false && next.historyDeleted == true) {
        ref.read(ramenViewModelProvider.notifier).refreshHistoryBrand();
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(title: '조리내역'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchableWidget(
            hintText: '조리했던 라면을 검색해보세요!',
            onSearch: historyNotifier.searchHistories,
            child: const HistoryBody(),
          ),
        ),
      ),
    );
  }
}