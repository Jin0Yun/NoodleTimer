import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/presentation/common/state/base_state.dart';

class NoodlePreferenceState implements BaseState {
  final NoodlePreference noodlePreference;
  final bool _isLoading;
  final String? _error;

  const NoodlePreferenceState({
    required this.noodlePreference,
    bool isLoading = false,
    String? error,
  }) : _isLoading = isLoading,
       _error = error;

  factory NoodlePreferenceState.initial() {
    return const NoodlePreferenceState(noodlePreference: NoodlePreference.none);
  }

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  NoodlePreferenceState copyWith({
    NoodlePreference? noodlePreference,
    bool? isLoading,
    String? error,
  }) {
    return NoodlePreferenceState(
      noodlePreference: noodlePreference ?? this.noodlePreference,
      isLoading: isLoading ?? _isLoading,
      error: error ?? _error,
    );
  }

  bool get hasPreference => noodlePreference != NoodlePreference.none;
}