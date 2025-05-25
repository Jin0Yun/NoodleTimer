import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'package:noodle_timer/presentation/common/utils/hangul_utils.dart';
import 'package:noodle_timer/presentation/history/state/history_state.dart';
import 'package:noodle_timer/presentation/common/viewmodel/base_view_model.dart';

class RecipeHistoryViewModel extends BaseViewModel<RecipeHistoryState> {
  final UserRepository _userRepository;
  final RamenRepository _ramenRepository;
  final Ref _ref;

  RecipeHistoryViewModel(
    this._userRepository,
    this._ramenRepository,
    AppLogger logger,
    this._ref,
  ) : super(logger, RecipeHistoryState.initial());

  @override
  RecipeHistoryState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  RecipeHistoryState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  RecipeHistoryState clearErrorState() {
    return state.copyWith(error: null);
  }

  Future<void> loadCookHistories() async {
    await runWithLoading(() async {
      final userId = _userRepository.getCurrentUserId();
      if (userId == null) {
        throw Exception('로그인이 필요합니다.');
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
              return history;
            } catch (e) {
              logger.e('라면 정보를 찾을 수 없습니다: ${history.ramenId}', e);
              return history;
            }
          }
          return history;
        }).toList(),
      );

      state = state.copyWith(
        histories: updatedHistories,
        filteredHistories: updatedHistories,
      );

      logger.d('조리 내역 불러오기 완료 (${updatedHistories.length}건)');
    });
  }

  void searchHistories(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(filteredHistories: state.histories);
      return;
    }

    final lowerQuery = trimmed.toLowerCase();
    final filtered =
        state.histories.where((item) {
          final name = item.displayName;
          return name.toLowerCase().contains(lowerQuery) ||
              HangulUtils.matchesChoSung(name, lowerQuery);
        }).toList();

    state = state.copyWith(filteredHistories: filtered);
  }

  Future<void> replayRecipe(CookHistoryEntity item) async {
    try {
      final ramenId = int.tryParse(item.ramenId);
      if (ramenId == null) {
        throw Exception('유효하지 않은 라면 ID: ${item.ramenId}');
      }

      final ramen = await _ramenRepository.findRamenById(ramenId);
      if (ramen == null) {
        throw Exception('라면 정보를 찾을 수 없습니다: $ramenId');
      }

      logger.d('다시 조리하기 선택됨: ${ramen.name}');

      _ref.read(ramenViewModelProvider.notifier).confirmRamenSelection(ramen);
      _ref.read(timerViewModelProvider.notifier).updateRamen(ramen);
    } catch (e) {
      logger.e('다시 조리하기 중 오류 발생', e);
    }
  }

  Future<void> deleteHistory(String historyId) async {
    await runWithLoading(() async {
      final userId = _userRepository.getCurrentUserId();
      if (userId == null) {
        throw Exception('사용자 인증 실패');
      }

      await _userRepository.deleteCookHistory(userId, historyId);
      logger.d('조리 내역 삭제 완료: $historyId');

      final updatedHistories =
          state.histories.where((item) => item.id != historyId).toList();
      state = state.copyWith(
        histories: updatedHistories,
        filteredHistories:
            state.filteredHistories
                .where((item) => item.id != historyId)
                .toList(),
      );
    });
  }
}
