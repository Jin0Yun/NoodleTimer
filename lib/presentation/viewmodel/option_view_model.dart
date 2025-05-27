import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/usecase/user_usecase.dart';
import 'package:noodle_timer/presentation/viewmodel/base_view_model.dart';
import 'package:noodle_timer/presentation/state/option_state.dart';

class OptionViewModel extends BaseViewModel<OptionState> {
  final UserUseCase _userUseCase;

  OptionViewModel(this._userUseCase, AppLogger logger)
    : super(logger, const OptionState());

  @override
  OptionState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  OptionState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  OptionState clearErrorState() {
    return state.copyWith(error: null);
  }

  void updateEggPreference(EggPreference preference) {
    state = state.copyWith(eggPreference: preference);
  }

  void updateNoodlePreference(NoodlePreference preference) {
    state = state.copyWith(noodlePreference: preference);
  }

  void updateEggPreferenceFromLabel(String label) {
    final preference = _mapToEggPreference(label);
    updateEggPreference(preference);
  }

  void updateNoodlePreferenceFromLabel(String label) {
    final preference = _mapToNoodlePreference(label);
    updateNoodlePreference(preference);
  }

  Future<void> loadUserPreferences() async {
    state = setLoadingState(true);
    try {
      final user = await _userUseCase.getCurrentUser();
      if (user != null) {
        state = state.copyWith(
          noodlePreference: user.noodlePreference,
          eggPreference: user.eggPreference,
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

  EggPreference _mapToEggPreference(String label) {
    switch (label) {
      case '반숙':
        return EggPreference.half;
      case '완숙':
        return EggPreference.full;
      default:
        return EggPreference.none;
    }
  }

  NoodlePreference _mapToNoodlePreference(String label) {
    switch (label) {
      case '퍼진면':
        return NoodlePreference.peojin;
      default:
        return NoodlePreference.kodul;
    }
  }
}