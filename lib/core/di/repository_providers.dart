import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/data/repository/auth_repository_impl.dart';
import 'package:noodle_timer/data/repository/ramen_repository_impl.dart';
import 'package:noodle_timer/data/repository/user_repository_impl.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'core_providers.dart';
import 'service_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final logger = ref.read(loggerProvider);
  return AuthRepositoryImpl(firebaseAuth: firebaseAuth, logger: logger);
});

final ramenRepositoryProvider = Provider<RamenRepository>((ref) {
  final dataLoader = ref.read(dataLoaderProvider);
  return RamenRepositoryImpl(dataLoader);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final firestoreService = ref.read(firestoreServiceProvider);
  final localStorage = ref.read(localStorageProvider);
  final logger = ref.read(loggerProvider);
  return UserRepositoryImpl(
    auth: firebaseAuth,
    firestoreService: firestoreService,
    localStorage: localStorage,
    logger: logger,
  );
});