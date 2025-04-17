import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/custom_search_bar.dart';
import 'package:noodle_timer/presentation/history/widget/recipe_history_card.dart';

class RecipeHistoryScreen extends StatelessWidget {
  RecipeHistoryScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  final searchNotifier = _DummySearchNotifier();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: NoodleColors.neutral100,
        centerTitle: true,
        elevation: 0,
        title: Text(
          '조리내역',
          style: NoodleTextStyles.titleSmBold.copyWith(
            color: NoodleColors.neutral1000,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                hintText: '조리했던 라면을 검색해보세요!',
                controller: _searchController,
                onClear: () {
                  _searchController.clear();
                  searchNotifier.resetSearch();
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    RecipeHistoryCard(
                      imageUrl: '',
                      name: '삼양라면',
                      cookedTime: '3분 50초 간 조리',
                      noodleState: '꼬들면',
                      eggState: '완숙',
                      onCookAgain: () {},
                      onDelete: () {},
                    ),
                    RecipeHistoryCard(
                      imageUrl: '',
                      name: '신라면',
                      cookedTime: '3분 50초 간 조리',
                      noodleState: '꼬들면',
                      eggState: '완숙',
                      onCookAgain: () {},
                      onDelete: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DummySearchNotifier {
  void resetSearch() {
    print("검색 초기화");
  }
}
