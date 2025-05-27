import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/presentation/state/base_state.dart';

class OptionState implements BaseState {
  final EggPreference eggPreference;
  final NoodlePreference noodlePreference;
  final bool _isLoading;
  final String? _error;

  const OptionState({
    this.eggPreference = EggPreference.none,
    this.noodlePreference = NoodlePreference.kodul,
    bool isLoading = false,
    String? error,
  }) : _isLoading = isLoading,
       _error = error;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  OptionState copyWith({
    EggPreference? eggPreference,
    NoodlePreference? noodlePreference,
    bool? isLoading,
    String? error,
  }) {
    return OptionState(
      eggPreference: eggPreference ?? this.eggPreference,
      noodlePreference: noodlePreference ?? this.noodlePreference,
      isLoading: isLoading ?? _isLoading,
      error: error,
    );
  }
}