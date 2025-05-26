import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/widget/custom_app_bar.dart';
import 'package:noodle_timer/presentation/common/widget/custom_search_bar.dart';
import 'package:noodle_timer/presentation/widget/history/history_body.dart';

class RecipeHistoryScreen extends ConsumerStatefulWidget {
  const RecipeHistoryScreen({super.key});

  @override
  ConsumerState<RecipeHistoryScreen> createState() =>
      _RecipeHistoryScreenState();
}

class _RecipeHistoryScreenState extends ConsumerState<RecipeHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyViewModelProvider.notifier).loadCookHistories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '조리내역'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                hintText: '조리했던 라면을 검색해보세요!',
                controller: _searchController,
                onChanged: (value) {
                  ref
                      .read(historyViewModelProvider.notifier)
                      .searchHistories(value);
                },
                onClear: () {
                  _searchController.clear();
                  ref
                      .read(historyViewModelProvider.notifier)
                      .searchHistories('');
                },
              ),
              const SizedBox(height: 16),
              const Expanded(child: HistoryBody()),
            ],
          ),
        ),
      ),
    );
  }
}