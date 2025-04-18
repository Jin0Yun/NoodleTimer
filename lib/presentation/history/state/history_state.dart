import 'package:noodle_timer/domain/entity/cook_history_entity.dart';

class RecipeHistoryState {
  final bool isLoading;
  final List<CookHistoryEntity> histories;
  final List<CookHistoryEntity> filteredHistories;

  const RecipeHistoryState({
    this.isLoading = false,
    this.histories = const [],
    this.filteredHistories = const [],
  });

  RecipeHistoryState copyWith({
    bool? isLoading,
    List<CookHistoryEntity>? histories,
    List<CookHistoryEntity>? filteredHistories,
  }) {
    return RecipeHistoryState(
      isLoading: isLoading ?? this.isLoading,
      histories: histories ?? this.histories,
      filteredHistories: filteredHistories ?? this.filteredHistories,
    );
  }

  factory RecipeHistoryState.initial() => const RecipeHistoryState();
}