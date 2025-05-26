import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/presentation/common/widget/custom_app_bar.dart';
import 'package:noodle_timer/presentation/screen/ramen_detail_screen.dart';
import 'package:noodle_timer/presentation/common/widget/custom_search_bar.dart';
import 'package:noodle_timer/presentation/widget/card/ramen_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final ramenState = ref.watch(ramenViewModelProvider);
        final ramenNotifier = ref.read(ramenViewModelProvider.notifier);

        return Scaffold(
          appBar: const CustomAppBar(title: '라면찾기'),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchBar(
                    hintText: '라면을 검색해주세요!',
                    controller: _searchController,
                    onChanged: (value) {
                      ramenNotifier.updateSearchKeyword(value.trim());
                    },
                    onClear: () {
                      _searchController.clear();
                      ramenNotifier.updateSearchKeyword('');
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: RamenList(
                      state: ramenState,
                      onTap: (context, selectedRamen) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => RamenDetailScreen(ramen: selectedRamen),
                          ),
                        ).then((_) {
                          _searchController.clear();
                          ramenNotifier.updateSearchKeyword('');
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}