import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/presentation/common/utils/hangul_utils.dart';
import 'package:noodle_timer/presentation/search/state/search_state.dart';
import 'package:noodle_timer/presentation/common/viewmodel/base_view_model.dart';

class SearchViewModel extends BaseViewModel<SearchState> {
  final RamenRepository _repository;

  SearchViewModel(this._repository, AppLogger logger)
    : super(logger, const SearchState()) {
    loadRamens();
  }

  @override
  SearchState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  SearchState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  SearchState clearErrorState() {
    return state.copyWith(error: null);
  }

  Future<void> loadRamens() async {
    await runWithLoading(() async {
      final allRamen = await _repository.loadAllRamen();
      state = state.copyWith(allRamen: allRamen);
      logger.i('라면 데이터 로딩 완료');
    }, showLoading: false);
  }

  void updateSearchKeyword(String keyword) {
    state = state.copyWith(searchKeyword: keyword);
    if (keyword.trim().isEmpty) {
      state = state.copyWith(searchResults: []);
    } else {
      final results = _searchRamen(keyword.trim());
      state = state.copyWith(searchResults: results);
    }
  }

  List<RamenEntity> _searchRamen(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    return state.allRamen
        .where(
          (ramen) =>
              ramen.name.toLowerCase().contains(lowerKeyword) ||
              HangulUtils.matchesChoSung(ramen.name, lowerKeyword),
        )
        .toList();
  }
}