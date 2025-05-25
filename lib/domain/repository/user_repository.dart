import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/user_entity.dart';

abstract class UserRepository {
  String? getCurrentUserId();
  Future<UserEntity?> getUserById(String uid);
  Stream<UserEntity?> getUserStream(String uid);
  Future<String> saveUser(UserEntity user);
  Future<void> updateNoodlePreference(String uid, NoodlePreference preference);
  Future<void> saveCookHistory(String uid, CookHistoryEntity history);
  Future<List<CookHistoryEntity>> getCookHistories(String uid);
  Future<void> deleteCookHistory(String uid, String historyId);
  Future<void> setNeedsOnboarding(bool needsOnboarding);
  Future<bool> getNeedsOnboarding();
}