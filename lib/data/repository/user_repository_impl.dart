import 'package:firebase_auth/firebase_auth.dart';
import 'package:noodle_timer/core/exceptions/user_error.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/user_entity.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'package:noodle_timer/data/service/firestore_service.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _auth;
  final FirestoreService _firestoreService;
  final AppLogger _logger;

  UserRepositoryImpl({
    required FirebaseAuth auth,
    required FirestoreService firestoreService,
    required AppLogger logger,
  })  : _auth = auth,
        _firestoreService = firestoreService,
        _logger = logger;

  @override
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  @override
  Future<UserEntity?> getUserById(String uid) async {
    try {
      final user = await _firestoreService.getUser(uid);
      return user;
    } catch (e) {
      _logger.e('사용자 정보 조회 실패: $uid', e);
      throw UserError(UserErrorType.userNotFound, '사용자 정보를 찾을 수 없습니다: $uid');
    }
  }

  @override
  Stream<UserEntity?> getUserStream(String uid) {
    return _firestoreService.getUserStream(uid);
  }

  @override
  Future<void> updateNoodlePreference(String uid, NoodlePreference preference) async {
    try {
      await _firestoreService.updateUserNoodlePreference(uid, preference);
      _logger.d('면 취향 업데이트: $uid, $preference');
    } catch (e) {
      _logger.e('면 취향 업데이트 실패: $uid', e);
      throw UserError(UserErrorType.updateFailed, '면 취향 업데이트 실패: $e');
    }
  }

  @override
  Future<void> saveCookHistory(String uid, CookHistoryEntity history) async {
    try {
      await _firestoreService.addCookHistory(uid, history);
      _logger.d('조리 기록 저장: $uid, 라면ID: ${history.ramenId}');
    } catch (e) {
      _logger.e('조리 기록 저장 실패: $uid', e);
      throw UserError(UserErrorType.saveFailed, '조리 기록 저장 실패: $e');
    }
  }

  @override
  Future<List<CookHistoryEntity>> getCookHistories(String uid) async {
    try {
      final histories = await _firestoreService.getCookHistories(uid);
      return histories;
    } catch (e) {
      _logger.e('조리 기록 목록 조회 실패: $uid', e);
      throw UserError(UserErrorType.loadFailed, '조리 기록 목록 조회 실패: $e');
    }
  }
}