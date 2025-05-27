import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/domain/usecase/auth_usecase.dart';
import 'package:noodle_timer/domain/usecase/cook_history_use_case.dart';
import 'package:noodle_timer/domain/usecase/user_usecase.dart';
import 'package:noodle_timer/domain/usecase/ramen_usecase.dart';
import 'repository_providers.dart';

final authUseCaseProvider = Provider<AuthUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  return AuthUseCase(authRepo, userRepo);
});

final userUseCaseProvider = Provider<UserUseCase>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  return UserUseCase(userRepo);
});

final ramenUseCaseProvider = Provider<RamenUseCase>((ref) {
  final ramenRepo = ref.watch(ramenRepositoryProvider);
  return RamenUseCase(ramenRepo);
});

final cookHistoryUseCaseProvider = Provider<CookHistoryUseCase>((ref) {
  final cookHistoryRepo = ref.watch(cookHistoryRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  return CookHistoryUseCase(cookHistoryRepo, userRepo);
});
