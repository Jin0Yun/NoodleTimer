import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/core/logger/console_logger.dart';
import 'package:noodle_timer/data/repository/auth_repository_impl.dart';
import 'package:noodle_timer/data/repository/ramen_repository_impl.dart';
import 'package:noodle_timer/data/service/data_loader.dart';
import 'package:noodle_timer/data/service/firestore_service.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/presentation/auth/viewmodel/login_view_model.dart';
import 'package:noodle_timer/presentation/auth/viewmodel/sign_up_view_model.dart';
import 'package:noodle_timer/presentation/home/state/timer_state.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_view_model.dart';
import 'package:noodle_timer/presentation/home/viewmodel/timer_view_model.dart';
import 'package:noodle_timer/presentation/search/state/search_state.dart';
import 'package:noodle_timer/presentation/search/viewmodel/search_view_model.dart';
import 'package:noodle_timer/presentation/onboarding/viewmodel/noodle_preference_view_model.dart';
import 'package:noodle_timer/presentation/auth/state/login_state.dart';
import 'package:noodle_timer/presentation/auth/state/sign_up_state.dart';
import 'package:noodle_timer/presentation/home/state/ramen_state.dart';
import 'package:noodle_timer/presentation/onboarding/state/noodle_preference_state.dart';

/// Firebase
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

/// Logger
final loggerProvider = Provider<AppLogger>((ref) => ConsoleLogger());

/// FirestoreService
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  final firestore = ref.read(firestoreProvider);
  final logger = ref.read(loggerProvider);
  return FirestoreService(logger, firestore: firestore);
});

/// Auth Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return AuthRepositoryImpl(firebaseAuth: firebaseAuth);
});

/// Ramen Repository
final dataLoaderProvider = Provider<IDataLoader>((ref) {
  return DataLoader();
});

final ramenRepositoryProvider = Provider<RamenRepository>((ref) {
  final dataLoader = ref.read(dataLoaderProvider);
  return RamenRepositoryImpl(dataLoader);
});

/// SignUp ViewModel
final signUpViewModelProvider = StateNotifierProvider<SignUpViewModel, SignUpState>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  final firestoreService = ref.read(firestoreServiceProvider);
  final logger = ref.read(loggerProvider);
  return SignUpViewModel(authRepo, firestoreService, logger);
});

/// Login ViewModel
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  final logger = ref.read(loggerProvider);
  return LoginViewModel(authRepo, logger);
});

/// Ramen ViewModel
final ramenViewModelProvider = StateNotifierProvider<RamenViewModel, RamenState>((ref) {
  final repo = ref.read(ramenRepositoryProvider);
  final logger = ref.read(loggerProvider);
  return RamenViewModel(repo, logger);
});

/// Search ViewModel
final searchViewModelProvider = StateNotifierProvider<SearchViewModel, SearchState>((ref) {
  final repo = ref.read(ramenRepositoryProvider);
  final logger = ref.read(loggerProvider);
  return SearchViewModel(repo, logger);
});

/// Noodle Preference ViewModel
final noodlePreferenceProvider = StateNotifierProvider.autoDispose<NoodlePreferenceViewModel, NoodlePreferenceState>((ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final userId = firebaseAuth.currentUser?.uid ?? '';
  final logger = ref.read(loggerProvider);
  return NoodlePreferenceViewModel(firestoreService, userId, logger);
});

/// Timer ViewModel
final timerViewModelProvider = StateNotifierProvider<TimerViewModel, TimerState>((ref) {
  final logger = ref.read(loggerProvider);
  return TimerViewModel(logger);
});