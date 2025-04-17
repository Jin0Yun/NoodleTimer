import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/user_entity.dart';

class FirestoreService {
  final FirebaseFirestore _db;
  final AppLogger _logger;

  FirestoreService(this._logger, {FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  Future<void> saveUser(UserEntity user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toMap());
      _logger.i('유저 정보 저장 성공: ${user.email}');
    } catch (e, st) {
      _logger.e('유저 정보 저장 중 오류 발생: $e', e, st);
      rethrow;
    }
  }

  Future<UserEntity?> getUser(String uid) async {
    try {
      final docSnapshot = await _db.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        _logger.i('유저 정보 조회 성공: $uid');
        return UserEntity.fromMap(docSnapshot.data()!);
      } else {
        _logger.i('해당 uid의 유저를 찾을 수 없습니다: $uid');
        return null;
      }
    } catch (e, st) {
      _logger.e('유저 정보 조회 중 오류 발생: $e', e, st);
      rethrow;
    }
  }

  Stream<UserEntity?> getUserStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.exists ? UserEntity.fromMap(snapshot.data()!) : null,
        );
  }

  Future<void> updateUserNoodlePreference(
    String uid,
    NoodlePreference preference,
  ) async {
    try {
      await _db.collection('users').doc(uid).update({
        'noodlePreference': preference.toShortString(),
      });
      _logger.i('유저 면발 취향 업데이트 성공: $uid, ${preference.toShortString()}');
    } catch (e, st) {
      _logger.e('유저 면발 취향 업데이트 중 오류 발생: $e', e, st);
      rethrow;
    }
  }

  Future<String> addCookHistory(String uid, CookHistoryEntity history) async {
    try {
      final docRef = await _db
          .collection('users')
          .doc(uid)
          .collection('cookHistories')
          .add(history.toMap());
      _logger.i('조리 기록 추가 성공: $uid / ${docRef.id}');
      return docRef.id;
    } catch (e, st) {
      _logger.e('조리 기록 추가 중 오류 발생', e, st);
      rethrow;
    }
  }

  Future<List<CookHistoryEntity>> getCookHistories(String uid) async {
    try {
      final snapshot =
          await _db
              .collection('users')
              .doc(uid)
              .collection('cookHistories')
              .orderBy('cookedAt', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => CookHistoryEntity.fromMap(doc.data()))
          .toList();
    } catch (e, st) {
      _logger.e('조리 기록 조회 중 오류 발생', e, st);
      rethrow;
    }
  }
}
