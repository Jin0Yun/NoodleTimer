import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/common/state/base_state.dart';

class SearchState implements BaseState {
  final String searchKeyword;
  final List<RamenEntity> allRamen;
  final List<RamenEntity> searchResults;
  final bool _isLoading;
  final String? _error;

  const SearchState({
    this.searchKeyword = '',
    this.allRamen = const [],
    this.searchResults = const [],
    bool isLoading = false,
    String? error,
  }) : _isLoading = isLoading,
       _error = error;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  SearchState copyWith({
    String? searchKeyword,
    List<RamenEntity>? allRamen,
    List<RamenEntity>? searchResults,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      searchKeyword: searchKeyword ?? this.searchKeyword,
      allRamen: allRamen ?? this.allRamen,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get hasKeyword => searchKeyword.isNotEmpty;
}