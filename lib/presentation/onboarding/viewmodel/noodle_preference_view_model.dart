import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/data/service/firestore_service.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/presentation/onboarding/state/noodle_preference_state.dart';

class NoodlePreferenceViewModel extends StateNotifier<NoodlePreferenceState> {
  final FirestoreService _firestoreService;
  final AppLogger _logger;
  final String _userId;

  NoodlePreferenceViewModel(this._firestoreService, this._userId, this._logger)
      : super(NoodlePreferenceState.initial());

  Future<void> updateNoodlePreference(NoodlePreference preference) async {
    final preferenceString = preference.toShortString();
    state = state.copyWith(status: AsyncValue.loading());
    try {
      await _firestoreService.updateUserNoodlePreference(_userId, preference);

      if (!mounted) return;
      state = state.copyWith(status: const AsyncValue.data(null));
      _logger.i('면발 취향 업데이트 성공: $_userId, $preferenceString');
    } catch (e, st) {
      _logger.e('면발 취향 업데이트 실패: $e', e, st);
      state = state.copyWith(status: AsyncValue.error(e, st));
    }
  }
}
