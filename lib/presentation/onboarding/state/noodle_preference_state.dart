import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';

class NoodlePreferenceState {
  final NoodlePreference noodlePreference;
  final AsyncValue<void> status;

  NoodlePreferenceState({
    required this.noodlePreference,
    required this.status,
  });

  factory NoodlePreferenceState.initial() {
    return NoodlePreferenceState(
      noodlePreference: NoodlePreference.none,
      status: const AsyncValue.data(null),
    );
  }

  NoodlePreferenceState copyWith({
    NoodlePreference? noodlePreference,
    AsyncValue<void>? status,
  }) {
    return NoodlePreferenceState(
      noodlePreference: noodlePreference ?? this.noodlePreference,
      status: status ?? this.status,
    );
  }

  bool get hasPreference => noodlePreference != NoodlePreference.none;
}
