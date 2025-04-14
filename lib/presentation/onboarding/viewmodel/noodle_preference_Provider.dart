import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/presentation/auth/viewmodel/auth_provider.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_provider.dart';
import 'package:noodle_timer/presentation/onboarding/state/noodle_preference_state.dart';
import 'package:noodle_timer/presentation/onboarding/viewmodel/noodle_preference_view_model.dart';

final noodlePreferenceProvider = StateNotifierProvider.autoDispose<NoodlePreferenceViewModel, NoodlePreferenceState>((ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final userId = firebaseAuth.currentUser?.uid ?? '';

  final logger = ref.read(loggerProvider);
  return NoodlePreferenceViewModel(firestoreService, userId, logger);
});
