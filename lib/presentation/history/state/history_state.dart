import 'package:noodle_timer/presentation/history/model/history_item.dart';

class RecipeHistoryState {
  final bool isLoading;
  final List<HistoryItem> histories;
  final List<HistoryItem> filteredHistories;

  const RecipeHistoryState({
    this.isLoading = false,
    this.histories = const [],
    this.filteredHistories = const [],
  });

  RecipeHistoryState copyWith({
    bool? isLoading,
    List<HistoryItem>? histories,
    List<HistoryItem>? filteredHistories,
  }) {
    return RecipeHistoryState(
      isLoading: isLoading ?? this.isLoading,
      histories: histories ?? this.histories,
      filteredHistories: filteredHistories ?? this.filteredHistories,
    );
  }

  factory RecipeHistoryState.initial() => const RecipeHistoryState();
}
