import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/enum/noodle_preference.dart';
import 'package:noodle_timer/presentation/state/base_state.dart';

class HistoryState implements BaseState {
  final List<CookHistoryEntity> histories;
  final List<CookHistoryEntity> filteredHistories;
  final NoodlePreference noodlePreference;
  final bool _isLoading;
  final String? _error;
  final bool historyDeleted;

  const HistoryState({
    this.histories = const [],
    this.filteredHistories = const [],
    this.noodlePreference = NoodlePreference.none,
    bool isLoading = false,
    String? error,
    this.historyDeleted = false,
  }) : _isLoading = isLoading,
       _error = error;

  factory HistoryState.initial() {
    return const HistoryState();
  }

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  bool get hasPreference => noodlePreference != NoodlePreference.none;
  bool get hasHistories => histories.isNotEmpty;

  HistoryState copyWith({
    List<CookHistoryEntity>? histories,
    List<CookHistoryEntity>? filteredHistories,
    NoodlePreference? noodlePreference,
    bool? isLoading,
    String? error,
    bool? historyDeleted,
  }) {
    return HistoryState(
      histories: histories ?? this.histories,
      filteredHistories: filteredHistories ?? this.filteredHistories,
      noodlePreference: noodlePreference ?? this.noodlePreference,
      isLoading: isLoading ?? _isLoading,
      error: error,
      historyDeleted: historyDeleted ?? false,
    );
  }
}