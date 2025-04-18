import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'package:noodle_timer/presentation/common/utils/hangul_utils.dart';
import 'package:noodle_timer/presentation/history/state/history_state.dart';

class RecipeHistoryViewModel extends StateNotifier<RecipeHistoryState> {
  final UserRepository _userRepository;
  final RamenRepository _ramenRepository;
  final AppLogger _logger;
  final Ref _ref;

  RecipeHistoryViewModel(
      this._userRepository,
      this._ramenRepository,
      this._logger,
      this._ref,
      ) : super(RecipeHistoryState.initial());

  Future<void> loadCookHistories() async {
    try {
      state = state.copyWith(isLoading: true);

      final userId = _userRepository.getCurrentUserId();
      if (userId == null) {
        _logger.e('로그인이 필요합니다.');
        state = state.copyWith(isLoading: false);
        return;
      }

      final cookHistories = await _userRepository.getCookHistories(userId);
      final updatedHistories = await Future.wait(
        cookHistories.map((history) async {
          if (history.ramenId.isNotEmpty) {
            final ramenId = int.tryParse(history.ramenId) ?? 0;
            try {
              final ramen = await _ramenRepository.findRamenById(ramenId);
              if (ramen != null) {
                return history.withRamenInfo(ramen.name, ramen.imageUrl);
              }
            } catch (e) {
              _logger.e('라면 정보를 찾을 수 없습니다: ${history.ramenId}', e);
            }
          }
          return history;
        }).toList(),
      );

      state = state.copyWith(
        isLoading: false,
        histories: updatedHistories,
        filteredHistories: updatedHistories,
      );

      _logger.d('조리 내역 불러오기 완료 (${updatedHistories.length}건)');
    } catch (e) {
      _logger.e('조리 내역 로드 중 오류 발생', e);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<List<CookHistoryEntity>> _mapCookHistoriesToHistoryItems(
      List<CookHistoryEntity> cookHistories,
      ) async {
    return Future.wait(
      cookHistories.map((history) async {
        final ramenId = int.tryParse(history.ramenId) ?? 0;
        RamenEntity? ramen;

        try {
          ramen = await _ramenRepository.findRamenById(ramenId);
        } catch (e) {
          _logger.e('라면 정보를 찾을 수 없습니다: ${history.ramenId}', e);
        }

        return CookHistoryEntity(
          id: history.id,
          ramenId: history.ramenId,
          ramenName: ramen?.name ?? '알 수 없는 라면',
          ramenImage: ramen?.imageUrl ?? '',
          cookedAt: history.cookedAt,
          cookTime: history.cookTime,
          noodleState: history.noodleState,
          eggPreference: history.eggPreference,
        );
      }).toList(),
    );
  }

  void searchHistories(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      resetSearch();
      return;
    }

    final lowerQuery = trimmed.toLowerCase();
    final filtered = state.histories.where((item) {
      final name = item.displayName;
      return name.toLowerCase().contains(lowerQuery) ||
          HangulUtils.matchesChoSung(name, lowerQuery);
    }).toList();

    state = state.copyWith(filteredHistories: filtered);
  }

  void resetSearch() {
    state = state.copyWith(filteredHistories: state.histories);
  }

  Future<void> cookAgain(CookHistoryEntity item) async {
    try {
      final ramenId = int.tryParse(item.ramenId);
      if (ramenId == null) {
        _logger.e('유효하지 않은 라면 ID: ${item.ramenId}');
        return;
      }

      final ramen = await _ramenRepository.findRamenById(ramenId);
      if (ramen == null) {
        _logger.e('라면 정보를 찾을 수 없습니다: $ramenId');
        return;
      }

      _logger.d('다시 조리하기 선택됨: ${ramen.name}');

      _ref.read(ramenViewModelProvider.notifier).confirmRamenSelection(ramen);
      _ref.read(timerViewModelProvider.notifier).updateRamen(ramen);
    } catch (e) {
      _logger.e('다시 조리하기 중 오류 발생', e);
    }
  }

  Future<void> deleteHistory(String historyId) async {
    try {
      state = state.copyWith(isLoading: true);

      final userId = _userRepository.getCurrentUserId();
      if (userId == null) {
        _logger.e('사용자 인증 실패');
        state = state.copyWith(isLoading: false);
        return;
      }

      await _userRepository.deleteCookHistory(userId, historyId);
      _logger.d('조리 내역 삭제 완료: $historyId');

      final updatedHistories =
      state.histories.where((item) => item.id != historyId).toList();

      state = state.copyWith(
        isLoading: false,
        histories: updatedHistories,
        filteredHistories:
        state.filteredHistories.where((item) => item.id != historyId).toList(),
      );
    } catch (e) {
      _logger.e('조리 내역 삭제 중 오류 발생', e);
      state = state.copyWith(isLoading: false);
    }
  }
}