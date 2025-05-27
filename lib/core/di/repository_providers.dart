import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/data/repository/auth_repository_impl.dart';
import 'package:noodle_timer/data/repository/cook_history_repository_impl.dart';
import 'package:noodle_timer/data/repository/ramen_repository_impl.dart';
import 'package:noodle_timer/data/repository/user_repository_impl.dart';
import 'package:noodle_timer/data/utils/data_loader.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/domain/repository/cook_history_repository.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'core_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final logger = ref.read(loggerProvider);
  return AuthRepositoryImpl(firebaseAuth: firebaseAuth, logger: logger);
});

final ramenRepositoryProvider = Provider<RamenRepository>((ref) {
  final dataLoader = DataLoader();
  final logger = ref.read(loggerProvider);
  return RamenRepositoryImpl(dataLoader: dataLoader, logger: logger);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final firestore = ref.read(firestoreProvider);
  final logger = ref.read(loggerProvider);
  return UserRepositoryImpl(
    auth: firebaseAuth,
    firestore: firestore,
    logger: logger,
  );
});

final cookHistoryRepositoryProvider = Provider<CookHistoryRepository>((ref) {
  return CookHistoryRepositoryImpl();
});