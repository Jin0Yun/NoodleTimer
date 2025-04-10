import 'package:noodle_timer/domain/entity/ramen_entity.dart';

class SearchState {
  final String searchKeyword;
  final List<RamenEntity> allRamen;
  final List<RamenEntity> searchResults;

  SearchState({
    this.searchKeyword = '',
    this.allRamen = const [],
    this.searchResults = const []
  });

  SearchState copyWith({
    String? searchKeyword,
    List<RamenEntity>? allRamen,
    List<RamenEntity>? searchResults
  }) {
    return SearchState(
      searchKeyword: searchKeyword ?? this.searchKeyword,
      allRamen: allRamen ?? this.allRamen,
      searchResults: searchResults ?? this.searchResults
    );
  }

  bool get hasKeyword => searchKeyword.isNotEmpty;
}
