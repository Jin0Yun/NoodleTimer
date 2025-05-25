import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/presentation/common/state/base_state.dart';

class HistoryState implements BaseState {
  final List<CookHistoryEntity> histories;
  final List<CookHistoryEntity> filteredHistories;
  final NoodlePreference noodlePreference;
  final bool _isLoading;
  final String? _error;

  const HistoryState({
    this.histories = const [],
    this.filteredHistories = const [],
    this.noodlePreference = NoodlePreference.none,
    bool isLoading = false,
    String? error,
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
  }) {
    return HistoryState(
      histories: histories ?? this.histories,
      filteredHistories: filteredHistories ?? this.filteredHistories,
      noodlePreference: noodlePreference ?? this.noodlePreference,
      isLoading: isLoading ?? _isLoading,
      error: error,
    );
  }
}