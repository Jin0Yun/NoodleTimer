import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'package:noodle_timer/presentation/home/state/ramen_state.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_action_type.dart';
import 'package:noodle_timer/presentation/common/viewmodel/base_view_model.dart';

class RamenViewModel extends BaseViewModel<RamenState> {
  final RamenRepository _repository;
  final UserRepository _userRepository;

  RamenViewModel(this._repository, this._userRepository, AppLogger logger)
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

  Future<void> initialize([int initialBrandIndex = 0]) async {
    logger.i('라면 뷰모델 초기화 시작');
    await loadBrands();
    if (state.brands.isNotEmpty) {
      selectBrand(initialBrandIndex);
    }
    logger.i('라면 뷰모델 초기화 완료');
  }

  Future<void> loadBrands() async {
    await runWithLoading(() async {
      final brands = await _repository.loadBrands();
      final updatedBrands = await _withUserCookHistory(brands);
      state = state.copyWith(brands: updatedBrands);
      logger.i('브랜드 + 나의 라면 기록 불러오기 성공');
    }, showLoading: false);
  }

  Future<List<RamenBrandEntity>> _withUserCookHistory(
    List<RamenBrandEntity> brands,
  ) async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) {
      logger.w('로그인된 유저 없음');
      return brands;
    }

    final histories = await _userRepository.getCookHistories(userId);
    final ramenHistoryList = <RamenEntity>[];

    for (final history in histories) {
      final ramenId = int.tryParse(history.ramenId.trim());
      if (ramenId == null) continue;
      try {
        final ramen = await _repository.findRamenById(ramenId);
        if (ramen != null) {
          ramenHistoryList.add(ramen);
        }
      } catch (e) {
        logger.w('라면 정보 조회 실패: $ramenId');
      }
    }

    final historyBrand = RamenBrandEntity(
      id: 0,
      name: '나의 라면 기록',
      ramens: ramenHistoryList,
    );

    return [historyBrand, ...brands];
  }

  void selectBrand(int index) {
    if (index < 0 || index >= state.brands.length) {
      logger.w('유효하지 않은 브랜드 인덱스 접근: $index');
      return;
    }

    final selected = state.brands[index];
    state = state.copyWith(
      selectedBrandIndex: index,
      currentRamenList: selected.ramens,
      clearSelectedRamen: true,
      clearTemporarySelected: true,
    );
    logger.d('브랜드 선택: ${selected.name} (${selected.ramens.length}개 라면)');
  }

  void selectRamen(RamenEntity ramen) {
    final isAlreadySelected = state.temporarySelectedRamen?.id == ramen.id;
    state = state.copyWith(
      temporarySelectedRamen: isAlreadySelected ? null : ramen,
    );
    logger.d('라면 임시 선택: ${ramen.name}');
  }

  void confirmRamenSelection(RamenEntity ramen) {
    state = state.copyWith(selectedRamen: ramen, clearTemporarySelected: true);
    logger.d('라면 선택 확정: ${ramen.name}, 조리시간: ${ramen.cookTime}초');
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
        logger.d("라면 상세 정보 보기: ${ramen.name}");
        break;
    }
  }
}