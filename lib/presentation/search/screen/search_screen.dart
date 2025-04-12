import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/search/screen/ramen_detail_screen.dart';
import 'package:noodle_timer/presentation/search/widget/ramen_list.dart';
import 'package:noodle_timer/presentation/search/widget/custom_search_bar.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_provider.dart';

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
        final searchState = ref.watch(searchViewModelProvider);
        final searchNotifier = ref.read(searchViewModelProvider.notifier);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: NoodleColors.neutral100,
            centerTitle: true,
            elevation: 0,
            title: Text(
              '라면찾기',
              style: NoodleTextStyles.titleSmBold.copyWith(
                color: NoodleColors.neutral1000,
              )
            ),
          ),
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
                      searchNotifier.updateSearchKeyword(value.trim());
                    },
                    onClear: () {
                      _searchController.clear();
                      searchNotifier.resetSearch();
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: RamenList(
                      state: searchState,
                      onTap: (context, selectedRamen) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => RamenDetailScreen(ramen: selectedRamen),
                          ),
                        ).then((_) {
                          _searchController.clear();
                          searchNotifier.resetSearch();
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
