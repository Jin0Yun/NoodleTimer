import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/presentation/common/utils/hangul_utils.dart';
import 'package:noodle_timer/presentation/search/state/search_state.dart';

class SearchViewModel extends StateNotifier<SearchState> {
  final RamenRepository _repository;
  final AppLogger _logger;

  SearchViewModel(this._repository, this._logger) : super(SearchState()) {
    loadRames();
  }

  Future<void> loadRames() async {
    try {
      final allRamen = await _repository.loadAllRamen();
      state = state.copyWith(allRamen: allRamen);
      _logger.i('라면 데이터 로딩 완료');
    } catch (e, st) {
      _logger.e('라면 로딩 실패', e, st);
    }
  }

  void updateSearchKeyword(String keyword) {
    final results = _filterRamen(state.allRamen, keyword);
    state = state.copyWith(searchKeyword: keyword, searchResults: results);
  }

  void resetSearch() {
    state = state.copyWith(searchKeyword: '', searchResults: []);
  }

  List<RamenEntity> _filterRamen(List<RamenEntity> ramens, String keyword) {
    return ramens
        .where(
          (ramen) =>
              ramen.name.contains(keyword) ||
              HangulUtils.matchesChoSung(ramen.name, keyword),
        )
        .toList();
  }
}
