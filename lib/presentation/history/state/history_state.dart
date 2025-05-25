import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/presentation/common/state/base_state.dart';

class RecipeHistoryState implements BaseState {
  final List<CookHistoryEntity> histories;
  final List<CookHistoryEntity> filteredHistories;
  final bool _isLoading;
  final String? _error;

  const RecipeHistoryState({
    this.histories = const [],
    this.filteredHistories = const [],
    bool isLoading = false,
    String? error,
  }) : _isLoading = isLoading,
       _error = error;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  RecipeHistoryState copyWith({
    List<CookHistoryEntity>? histories,
    List<CookHistoryEntity>? filteredHistories,
    bool? isLoading,
    String? error,
  }) {
    return RecipeHistoryState(
      histories: histories ?? this.histories,
      filteredHistories: filteredHistories ?? this.filteredHistories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory RecipeHistoryState.initial() => const RecipeHistoryState();
}