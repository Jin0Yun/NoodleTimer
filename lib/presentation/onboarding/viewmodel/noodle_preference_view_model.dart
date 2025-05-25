import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'package:noodle_timer/presentation/onboarding/state/noodle_preference_state.dart';
import 'package:noodle_timer/presentation/common/viewmodel/base_view_model.dart';

class NoodlePreferenceViewModel extends BaseViewModel<NoodlePreferenceState> {
  final UserRepository _userRepository;
  final String _userId;

  NoodlePreferenceViewModel(
    this._userRepository,
    this._userId,
    AppLogger logger,
  ) : super(logger, NoodlePreferenceState.initial());

  @override
  NoodlePreferenceState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  NoodlePreferenceState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  NoodlePreferenceState clearErrorState() {
    return state.copyWith(error: null);
  }

  void selectPreference(NoodlePreference preference) {
    state = state.copyWith(noodlePreference: preference);
  }

  Future<void> updateNoodlePreference(NoodlePreference preference) async {
    await runWithLoading(() async {
      await _userRepository.updateNoodlePreference(_userId, preference);
      logger.i('면발 취향 업데이트 성공: $_userId, ${preference.name}');
      state = state.copyWith(noodlePreference: preference);
    });
  }
}