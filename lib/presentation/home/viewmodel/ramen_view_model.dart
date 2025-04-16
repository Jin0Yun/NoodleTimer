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
    _logger.i('라면 뷰모델 초기화 시작');
    await loadBrands();
    if (state.brands.isNotEmpty) {
      selectBrand(initialBrandIndex);
    }
    _logger.i('라면 뷰모델 초기화 완료');
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
    } catch (e, st) {
      _logger.e('브랜드 불러오기 중 예상치 못한 오류', e, st);
    }
  }

  void selectBrand(int index) {
    try {
      if (index < 0 || index >= state.brands.length) {
        _logger.d('유효하지 않은 브랜드 인덱스: $index');
        return;
      }

      final selected = state.brands[index];
      state = state.copyWith(
        currentRamenList: selected.ramens,
        selectedBrandIndex: index,
        clearSelectedRamen: true,
        clearTemporarySelected: true,
      );
      _logger.i('브랜드 선택: ${selected.name} (${selected.ramens.length}개 라면)');
    } catch (e, st) {
      _logger.e('브랜드 선택 실패: index $index', e, st);
    }
  }

  void selectRamen(RamenEntity ramen) {
    _logger.i('라면 임시 선택: ${ramen.name}');
    final isAlreadySelected = state.temporarySelectedRamen?.id == ramen.id;

    state = state.copyWith(
      temporarySelectedRamen: isAlreadySelected ? null : ramen,
    );
  }

  void confirmRamenSelection(RamenEntity ramen) {
    _logger.i('라면 선택 확정: ${ramen.name}, 조리시간: ${ramen.cookTime}초');
    state = state.copyWith(
        selectedRamen: ramen,
        clearTemporarySelected: true
    );
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
        showRamenDetail(ramen);
        break;
    }
  }

  void showRamenDetail(RamenEntity ramen) {
    _logger.i("라면 상세 정보 보기: ${ramen.name}");
  }
}