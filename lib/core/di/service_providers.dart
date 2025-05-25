import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/data/service/data_loader.dart';
import 'package:noodle_timer/data/service/firestore_service.dart';
import 'package:noodle_timer/data/service/local_storage_service.dart';
import 'package:noodle_timer/data/service/shared_preferences_service.dart';
import 'core_providers.dart';

final dataLoaderProvider = Provider<IDataLoader>((ref) => DataLoader());
final localStorageProvider = Provider<LocalStorageService>(
  (ref) => SharedPreferencesService(),
);

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  final firestore = ref.read(firestoreProvider);
  final logger = ref.read(loggerProvider);
  return FirestoreService(logger, firestore: firestore);
});