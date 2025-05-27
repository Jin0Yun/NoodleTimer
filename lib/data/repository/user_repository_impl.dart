import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noodle_timer/domain/enum/noodle_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noodle_timer/core/exceptions/user_exception.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/user_entity.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  UserRepositoryImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required AppLogger logger,
  }) : _auth = auth,
       _firestore = firestore,
       _logger = logger;

  @override
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  @override
  Future<UserEntity?> getUserById(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        _logger.i('유저 정보 조회 성공: $uid');
        return UserEntity.fromMap(docSnapshot.data()!);
      } else {
        _logger.i('해당 uid의 유저를 찾을 수 없습니다: $uid');
        return null;
      }
    } catch (e) {
      _logger.e('사용자 정보 조회 실패: $uid', e);
      if (e is FirebaseException) {
        throw UserException.fromFirebaseException(e);
      } else {
        throw UserException(UserErrorType.userNotFound, e.toString());
      }
    }
  }

  @override
  Stream<UserEntity?> getUserStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.exists ? UserEntity.fromMap(snapshot.data()!) : null,
        );
  }

  @override
  Future<String> saveUser(UserEntity user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      _logger.i('유저 정보 저장 성공: ${user.email}');
      return user.uid;
    } catch (e) {
      _logger.e('유저 정보 저장 중 오류 발생: $e', e);
      if (e is FirebaseException) {
        throw UserException.fromFirebaseException(e);
      } else {
        throw UserException(UserErrorType.saveFailed, e.toString());
      }
    }
  }

  @override
  Future<void> updateNoodlePreference(
    String uid,
    NoodlePreference preference,
  ) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'noodlePreference': preference.toString(),
      });
      _logger.i('유저 면발 취향 업데이트 성공: $uid, ${preference.toString()}');
    } catch (e) {
      _logger.e('면 취향 업데이트 실패: $uid', e);
      if (e is FirebaseException) {
        throw UserException.fromFirebaseException(e);
      } else {
        throw UserException(UserErrorType.updateFailed, e.toString());
      }
    }
  }

  @override
  Future<void> saveCookHistory(String uid, CookHistoryEntity history) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('cookHistories')
          .add(history.toMap());
      _logger.i('조리 기록 추가 성공: $uid / ${docRef.id}');
    } catch (e) {
      _logger.e('조리 기록 저장 실패: $uid', e);
      if (e is FirebaseException) {
        throw UserException.fromFirebaseException(e);
      } else {
        throw UserException(UserErrorType.saveFailed, e.toString());
      }
    }
  }

  @override
  Future<List<CookHistoryEntity>> getCookHistories(String uid) async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('cookHistories')
              .orderBy('cookedAt', descending: true)
              .get();

      return snapshot.docs.map((doc) {
        return CookHistoryEntity.fromMap({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      _logger.e('조리 기록 목록 조회 실패: $uid', e);
      if (e is FirebaseException) {
        throw UserException.fromFirebaseException(e);
      } else {
        throw UserException(UserErrorType.loadFailed, e.toString());
      }
    }
  }

  @override
  Future<void> deleteCookHistory(String uid, String historyId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('cookHistories')
          .doc(historyId)
          .delete();
      _logger.i('조리 기록 삭제 성공: $uid / $historyId');
    } catch (e) {
      _logger.e('조리 기록 삭제 실패: $uid', e);
      if (e is FirebaseException) {
        throw UserException.fromFirebaseException(e);
      } else {
        throw UserException(UserErrorType.deleteFailed, e.toString());
      }
    }
  }

  @override
  Future<void> setNeedsOnboarding(bool needsOnboarding) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('needsOnboarding', needsOnboarding);
      _logger.d('온보딩 플래그 설정: $needsOnboarding');
    } catch (e) {
      _logger.e('온보딩 플래그 설정 실패', e);
      throw UserException(UserErrorType.updateFailed, e.toString());
    }
  }

  @override
  Future<bool> getNeedsOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final needsOnboarding = prefs.getBool('needsOnboarding') ?? false;
      _logger.d('온보딩 플래그 조회: $needsOnboarding');
      return needsOnboarding;
    } catch (e) {
      _logger.e('온보딩 플래그 조회 실패', e);
      return false;
    }
  }
}