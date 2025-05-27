import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/cook_history_repository.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';

class CookHistoryUseCase {
  final CookHistoryRepository _cookHistoryRepository;
  final UserRepository _userRepository;

  CookHistoryUseCase(this._cookHistoryRepository, this._userRepository);

  Future<void> saveCookHistoryWithPreferences(
    RamenEntity ramen,
    NoodlePreference noodlePreference,
    EggPreference eggPreference,
    Duration cookTime,
  ) async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }

    final cookHistory = CookHistoryEntity(
      ramenId: ramen.id,
      ramenName: ramen.name,
      ramenImageUrl: ramen.imageUrl,
      cookedAt: DateTime.now(),
      noodleState: noodlePreference,
      eggPreference: eggPreference,
      cookTime: cookTime,
    );

    await _cookHistoryRepository.saveCookHistory(userId, cookHistory);
  }

  Future<void> saveCookHistory(RamenEntity ramen) async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }

    final cookHistory = CookHistoryEntity(
      ramenId: ramen.id,
      ramenName: ramen.name,
      ramenImageUrl: ramen.imageUrl,
      cookedAt: DateTime.now(),
      noodleState: NoodlePreference.kodul,
      eggPreference: EggPreference.none,
      cookTime: Duration(seconds: ramen.cookTime),
    );

    await _cookHistoryRepository.saveCookHistory(userId, cookHistory);
  }

  Future<List<CookHistoryEntity>> getCookHistoriesWithRamenInfo() async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) return [];

    return await _cookHistoryRepository.getCookHistories(userId);
  }

  Future<void> deleteCookHistory(String historyId) async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) return;

    await _cookHistoryRepository.deleteCookHistory(userId, historyId);
  }

  Future<List<RamenEntity>> getRamenHistoryList() async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) return [];

    return await _cookHistoryRepository.getRamenHistoryList(userId);
  }
}