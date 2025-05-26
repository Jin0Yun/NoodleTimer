import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';

class CookHistoryUseCase {
  final UserRepository _userRepository;
  final RamenRepository _ramenRepository;

  CookHistoryUseCase(this._userRepository, this._ramenRepository);

  Future<List<CookHistoryEntity>> getCookHistoriesWithRamenInfo() async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) {
      throw Exception('로그인이 필요합니다.');
    }

    final cookHistories = await _userRepository.getCookHistories(userId);
    final updatedHistories = await Future.wait(
      cookHistories.map((history) async {
        if (history.ramenId.isNotEmpty) {
          final ramenId = int.tryParse(history.ramenId) ?? 0;
          try {
            final ramen = await _ramenRepository.findRamenById(ramenId);
            if (ramen != null) {
              return history.withRamenInfo(ramen.name, ramen.imageUrl);
            }
            return history;
          } catch (e) {
            return history;
          }
        }
        return history;
      }).toList(),
    );

    return updatedHistories;
  }

  Future<void> saveCookHistory(RamenEntity ramen) async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) {
      throw Exception('조리 기록 저장 실패: 유저 정보 없음');
    }

    final history = CookHistoryEntity(
      ramenId: ramen.id.toString(),
      cookedAt: DateTime.now(),
      noodleState: NoodlePreference.kodul,
      eggPreference: EggPreference.none,
      cookTime: Duration(seconds: ramen.cookTime),
    );

    await _userRepository.saveCookHistory(userId, history);
  }

  Future<void> deleteCookHistory(String historyId) async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) {
      throw Exception('사용자 인증 실패');
    }
    await _userRepository.deleteCookHistory(userId, historyId);
  }

  Future<List<RamenEntity>> getRamenHistoryList() async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) {
      return [];
    }

    final histories = await _userRepository.getCookHistories(userId);
    final ramenHistoryList = <RamenEntity>[];

    for (final history in histories) {
      final ramenId = int.tryParse(history.ramenId.trim());
      if (ramenId == null) continue;

      final ramen = await _ramenRepository.findRamenById(ramenId);
      if (ramen != null) {
        ramenHistoryList.add(ramen);
      }
    }
    return ramenHistoryList;
  }
}