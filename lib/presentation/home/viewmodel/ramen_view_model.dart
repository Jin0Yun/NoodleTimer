import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'package:noodle_timer/presentation/home/state/ramen_state.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_action_type.dart';

class RamenViewModel extends StateNotifier<RamenState> {
  final RamenRepository _repository;
  final UserRepository _userRepository;
  final AppLogger _logger;

  RamenViewModel(this._repository, this._userRepository, this._logger)
      : super(const RamenState());

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
      final updatedBrands = await _withUserCookHistory(brands);
      state = state.copyWith(brands: updatedBrands);
      _logger.i('브랜드 + 나의 라면 기록 불러오기 성공');
    } catch (e, st) {
      _logger.e('loadBrands 실패', e, st);
    }
  }

  Future<List<RamenBrandEntity>> _withUserCookHistory(List<RamenBrandEntity> brands) async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) {
      _logger.w('로그인된 유저 없음');
      return brands;
    }

    final histories = await _userRepository.getCookHistories(userId);
    final ramenHistoryList = <RamenEntity>[];

    for (final history in histories) {
      final ramenId = int.tryParse(history.ramenId.trim());
      if (ramenId == null) continue;
      final ramen = await _repository.findRamenById(ramenId);
      if (ramen != null) ramenHistoryList.add(ramen);
    }

    final historyBrand = RamenBrandEntity(
      id: -1,
      name: "나의 라면 기록",
      ramens: ramenHistoryList,
    );

    return [historyBrand, ...brands];
  }

  void selectBrand(int index) {
    if (index < 0 || index >= state.brands.length) {
      _logger.w('유효하지 않은 브랜드 인덱스 접근: $index');
      return;
    }

    final selected = state.brands[index];
    state = state.copyWith(
      currentRamenList: selected.ramens,
      selectedBrandIndex: index,
      clearSelectedRamen: true,
      clearTemporarySelected: true,
    );
    _logger.d('브랜드 선택: ${selected.name} (${selected.ramens.length}개 라면)');
  }

  void selectRamen(RamenEntity ramen) {
    final isAlreadySelected = state.temporarySelectedRamen == ramen;
    state = state.copyWith(
      temporarySelectedRamen: isAlreadySelected ? null : ramen,
    );
    _logger.d('라면 임시 선택: ${ramen.name}');
  }

  void confirmRamenSelection(RamenEntity ramen) {
    state = state.copyWith(
      selectedRamen: ramen,
      clearTemporarySelected: true
    );
    _logger.d('라면 선택 확정: ${ramen.name}, 조리시간: ${ramen.cookTime}초');
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
        _logger.d("라면 상세 정보 보기: ${ramen.name}");
        break;
    }
  }
}