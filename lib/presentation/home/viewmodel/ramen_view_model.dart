import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/exceptions/ramen_error.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/presentation/home/state/ramen_state.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_action_type.dart';

class RamenViewModel extends StateNotifier<RamenState> {
  final RamenRepository _repository;
  final AppLogger _logger;

  RamenViewModel(this._repository, this._logger) : super(const RamenState());

  Future<void> initialize([int initialBrandIndex = 0]) async {
    await loadBrands();
    if (state.brands.isNotEmpty) {
      selectBrand(initialBrandIndex);
    }
  }

  Future<void> loadBrands() async {
    try {
      final brands = await _repository.loadBrands();

      final updatedBrands = [
        RamenBrandEntity(id: -1, name: "나의 라면 기록", ramens: []),
        ...brands,
      ];

      state = state.copyWith(brands: updatedBrands);
      _logger.i('라면 브랜드 불러오기 성공: (${updatedBrands.length}개)');
    } on RamenError catch (e, st) {
      _logger.e('브랜드 불러오기 실패', e, st);
    }
  }

  void selectBrand(int index) {
    try {
      if (index >= 0 && index < state.brands.length) {
        final selected = state.brands[index];
        state = state.copyWith(
          currentRamenList: selected.ramens,
          selectedBrandIndex: index,
          clearSelectedRamen: true,
        );
        _logger.i('라면 불러오기 성공: ${selected.name} (${selected.ramens.length}개)');
      }
    } catch (e, st) {
      _logger.e('브랜드 선택 실패: index $index', e, st);
    }
  }

  void toggleRamenSelection(RamenEntity ramen) {
    if (state.selectedRamen?.id == ramen.id) {
      state = state.copyWith(clearSelectedRamen: true);
    } else {
      state = state.copyWith(
        temporarySelectedRamen: ramen,
      );
    }
  }

  void handleRamenAction(RamenEntity ramen, RamenActionType actionType) {
    switch (actionType) {
      case RamenActionType.select:
        toggleRamenSelection(ramen);
        break;
      case RamenActionType.cook:
        _logger.i("라면 선택 완료 - ${ramen.name}");
        state = state.copyWith(selectedRamen: ramen, clearTemporarySelected: true);
        break;
      case RamenActionType.detail:
        _logger.i("상세 보기: ${ramen.name}");
        break;
    }
  }
}