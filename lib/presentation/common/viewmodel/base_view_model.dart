import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/presentation/common/state/base_state.dart';

abstract class BaseViewModel<T extends BaseState> extends StateNotifier<T> {
  final AppLogger logger;

  BaseViewModel(this.logger, T initialState) : super(initialState);

  T setLoadingState(bool isLoading);
  T setErrorState(String? error);
  T clearErrorState();

  Future<R> runWithLoading<R>(
      Future<R> Function() action, {
        bool showLoading = true,
      }) async {
    if (showLoading) {
      state = setLoadingState(true);
    }

    try {
      final result = await action();
      return result;
    } catch (e) {
      state = setErrorState(e.toString());
      rethrow;
    } finally {
      if (showLoading) {
        state = setLoadingState(false);
      }
    }
  }

  void resetError() {
    state = clearErrorState();
  }
}