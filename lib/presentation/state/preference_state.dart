import 'package:noodle_timer/domain/enum/noodle_preference.dart';
import 'package:noodle_timer/presentation/state/base_state.dart';

class PreferenceState implements BaseState {
  final NoodlePreference noodlePreference;
  final bool _isLoading;
  final String? _error;

  const PreferenceState({
    this.noodlePreference = NoodlePreference.none,
    bool isLoading = false,
    String? error,
  }) : _isLoading = isLoading,
       _error = error;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  PreferenceState copyWith({
    NoodlePreference? noodlePreference,
    bool? isLoading,
    String? error,
  }) {
    return PreferenceState(
      noodlePreference: noodlePreference ?? this.noodlePreference,
      isLoading: isLoading ?? _isLoading,
      error: error,
    );
  }
}