import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/widget/custom_app_bar.dart';
import 'package:noodle_timer/presentation/common/widget/searchable_widget.dart';
import 'package:noodle_timer/presentation/screen/ramen_detail_screen.dart';
import 'package:noodle_timer/presentation/widget/card/ramen_list.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ramenState = ref.watch(ramenViewModelProvider);
    final ramenNotifier = ref.read(ramenViewModelProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(title: '라면찾기'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchableWidget(
            hintText: '라면을 검색해주세요!',
            onSearch: ramenNotifier.updateSearchKeyword,
            child: RamenList(
              state: ramenState,
              onTap: (context, selectedRamen) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RamenDetailScreen(ramen: selectedRamen),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
