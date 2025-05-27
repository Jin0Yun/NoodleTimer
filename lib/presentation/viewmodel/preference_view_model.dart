import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/usecase/user_usecase.dart';
import 'package:noodle_timer/presentation/viewmodel/base_view_model.dart';
import 'package:noodle_timer/presentation/state/preference_state.dart';

class PreferenceViewModel extends BaseViewModel<PreferenceState> {
  final UserUseCase _userUseCase;
  final String _userId;

  PreferenceViewModel(this._userUseCase, this._userId, AppLogger logger)
    : super(logger, const PreferenceState());

  @override
  PreferenceState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  PreferenceState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  PreferenceState clearErrorState() {
    return state.copyWith(error: null);
  }

  void updateNoodlePreference(NoodlePreference preference) {
    state = state.copyWith(noodlePreference: preference);
  }

  Future<bool> savePreferences() async {
    state = setLoadingState(true);
    try {
      await _userUseCase.updateNoodlePreference(
        _userId,
        state.noodlePreference,
      );
      state = setLoadingState(false);
      return true;
    } catch (e) {
      state = setErrorState(e.toString());
      state = setLoadingState(false);
      return false;
    }
  }

  Future<void> loadUserPreferences() async {
    state = setLoadingState(true);
    try {
      final user = await _userUseCase.getCurrentUser();
      if (user != null) {
        state = state.copyWith(
          noodlePreference: user.noodlePreference,
          isLoading: false,
        );
      } else {
        state = setLoadingState(false);
      }
    } catch (e) {
      state = setErrorState(e.toString());
      state = setLoadingState(false);
    }
  }
}