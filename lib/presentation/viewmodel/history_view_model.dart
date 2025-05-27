import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/usecase/cook_history_use_case.dart';
import 'package:noodle_timer/domain/usecase/ramen_usecase.dart';
import 'package:noodle_timer/presentation/common/utils/hangul_utils.dart';
import 'package:noodle_timer/presentation/viewmodel/base_view_model.dart';
import 'package:noodle_timer/presentation/state/history_state.dart';

class HistoryViewModel extends BaseViewModel<HistoryState> {
  final RamenUseCase _ramenUseCase;
  final CookHistoryUseCase _cookHistoryUseCase;

  HistoryViewModel(
    this._ramenUseCase,
    this._cookHistoryUseCase,
    AppLogger logger,
  ) : super(logger, HistoryState.initial());

  @override
  HistoryState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  HistoryState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  HistoryState clearErrorState() {
    return state.copyWith(error: null);
  }

  Future<bool> loadCookHistories() async {
    state = setLoadingState(true);
    try {
      final updatedHistories =
          await _cookHistoryUseCase.getCookHistoriesWithRamenInfo();
      state = state.copyWith(
        histories: updatedHistories,
        filteredHistories: updatedHistories,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = setErrorState(e.toString());
      state = setLoadingState(false);
      return false;
    }
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

  Future<CookHistoryEntity?> getReplayData(CookHistoryEntity item) async {
    try {
      final ramen = await _ramenUseCase.getRamenById(item.ramenId);
      if (ramen == null) {
        throw Exception('라면 정보를 찾을 수 없습니다: ${item.ramenId}');
      }
      return item.copyWith(ramenName: ramen.name);
    } catch (e) {
      state = setErrorState('다시 조리하기에 실패했습니다.');
      return null;
    }
  }

  Future<bool> deleteHistory(String historyId) async {
    state = setLoadingState(true);
    try {
      await _cookHistoryUseCase.deleteCookHistory(historyId);
      final updatedHistories =
          state.histories.where((item) => item.id != historyId).toList();
      state = state.copyWith(
        histories: updatedHistories,
        filteredHistories:
            state.filteredHistories
                .where((item) => item.id != historyId)
                .toList(),
        isLoading: false,
        historyDeleted: true,
      );

      Future.microtask(() {
        state = state.copyWith(historyDeleted: false);
      });

      return true;
    } catch (e) {
      state = setErrorState(e.toString());
      state = setLoadingState(false);
      return false;
    }
  }
}