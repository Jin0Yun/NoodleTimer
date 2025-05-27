import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/usecase/cook_history_use_case.dart';
import 'package:noodle_timer/domain/usecase/ramen_usecase.dart';
import 'package:noodle_timer/domain/enum/ramen_action_type.dart';
import 'package:noodle_timer/presentation/viewmodel/base_view_model.dart';
import 'package:noodle_timer/presentation/state/ramen_state.dart';

class RamenViewModel extends BaseViewModel<RamenState> {
  final RamenUseCase _ramenUseCase;
  final CookHistoryUseCase _cookHistoryUseCase;

  RamenViewModel(this._ramenUseCase, this._cookHistoryUseCase, AppLogger logger)
    : super(logger, const RamenState());

  @override
  RamenState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  RamenState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  RamenState clearErrorState() {
    return state.copyWith(error: null);
  }

  Future<bool> initialize([int initialBrandIndex = 0]) async {
    if (state.brands.isNotEmpty) return true;

    return await runWithLoading(() async {
      final brands = await _ramenUseCase.loadBrands();
      final allRamen = brands.expand((brand) => brand.ramens).toList();
      final ramenHistoryList = await _cookHistoryUseCase.getRamenHistoryList();

      final historyBrand = RamenBrandEntity(
        id: 0,
        name: '나의 라면 기록',
        ramens: ramenHistoryList,
      );

      final brandsWithHistory = [historyBrand, ...brands];

      state = state.copyWith(brands: brandsWithHistory, allRamen: allRamen);

      if (state.brands.isNotEmpty) {
        selectBrand(initialBrandIndex);
      }

      return true;
    });
  }

  void selectBrand(int index) {
    if (index < 0 || index >= state.brands.length) {
      return;
    }

    final selected = state.brands[index];
    state = state.copyWith(
      selectedBrandIndex: index,
      currentRamenList: selected.ramens,
      clearSelectedRamen: true,
      clearTemporarySelected: true,
    );
  }

  void selectRamen(RamenEntity ramen) {
    final isAlreadySelected = state.temporarySelectedRamen?.id == ramen.id;
    state = state.copyWith(
      temporarySelectedRamen: isAlreadySelected ? null : ramen,
    );
  }

  void confirmRamenSelection(RamenEntity ramen) {
    state = state.copyWith(selectedRamen: ramen, clearTemporarySelected: true);
  }

  void handleRamenAction(RamenEntity ramen, RamenActionType actionType) {
    switch (actionType) {
      case RamenActionType.select:
        selectRamen(ramen);
        break;
      case RamenActionType.cook:
        confirmRamenSelection(ramen);
        break;
      case RamenActionType.detail:
        break;
    }
  }

  Future<void> updateSearchKeyword(String keyword) async {
    state = state.copyWith(searchKeyword: keyword);
    if (keyword.trim().isEmpty) {
      state = state.copyWith(searchResults: []);
      return;
    }

    final results = await _ramenUseCase.searchRamen(
      keyword.trim(),
      state.allRamen,
    );
    state = state.copyWith(searchResults: results);
  }

  Future<void> refreshHistoryBrand() async {
    if (state.brands.isEmpty) return;

    final updatedRamens = await _cookHistoryUseCase.getRamenHistoryList();
    final updatedHistoryBrand = state.brands[0].copyWith(ramens: updatedRamens);
    final updatedBrands = [...state.brands];
    updatedBrands[0] = updatedHistoryBrand;

    state = state.copyWith(
      brands: updatedBrands,
      currentRamenList:
          state.selectedBrandIndex == 0
              ? updatedRamens
              : state.currentRamenList,
    );
  }

  Future<void> removeHistoryRamen(String historyId) async {
    await refreshHistoryBrand();
  }

  Future<void> addHistoryRamen(RamenEntity ramen) async {
    await refreshHistoryBrand();
  }
}