import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/cook_history_repository.dart';

class CookHistoryRepositoryImpl implements CookHistoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveCookHistory(
    String userId,
    CookHistoryEntity cookHistory,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cookHistories')
          .add(cookHistory.toMap());
    } catch (e) {
      throw Exception('요리 기록 저장 실패: $e');
    }
  }

  @override
  Future<List<CookHistoryEntity>> getCookHistories(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cookHistories')
              .orderBy('cookedAt', descending: true)
              .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return CookHistoryEntity.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('요리 기록 조회 실패: $e');
    }
  }

  @override
  Future<void> deleteCookHistory(String userId, String historyId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cookHistories')
          .doc(historyId)
          .delete();
    } catch (e) {
      throw Exception('요리 기록 삭제 실패: $e');
    }
  }

  @override
  Future<List<RamenEntity>> getRamenHistoryList(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cookHistories')
              .orderBy('cookedAt', descending: true)
              .limit(10)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      final ramenList = <RamenEntity>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final ramenId = data['ramenId'] as int;
        final ramenName = data['ramenName'] as String;
        final ramenImageUrl = data['ramenImageUrl'] as String;

        final cookTimeData = data['cookTime'];
        int cookTimeInSeconds = 150;

        if (cookTimeData is int) {
          cookTimeInSeconds = cookTimeData;
        } else if (cookTimeData is Map) {
          cookTimeInSeconds = (cookTimeData['inSeconds'] as int?) ?? 150;
        }

        ramenList.add(
          RamenEntity(
            id: ramenId,
            name: ramenName,
            imageUrl: ramenImageUrl,
            spicyLevel: '보통',
            description: '조리 기록에서 불러온 라면',
            recipe: '',
            afterSeasoning: false,
            cookTime: cookTimeInSeconds,
          ),
        );
      }

      return ramenList;
    } catch (e) {
      throw Exception('라면 기록 목록 조회 실패: $e');
    }
  }
}