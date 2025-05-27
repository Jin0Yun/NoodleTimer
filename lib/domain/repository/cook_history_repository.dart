import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';

abstract class CookHistoryRepository {
  Future<void> saveCookHistory(String userId, CookHistoryEntity cookHistory);
  Future<List<CookHistoryEntity>> getCookHistories(String userId);
  Future<void> deleteCookHistory(String userId, String historyId);
  Future<List<RamenEntity>> getRamenHistoryList(String userId);
}