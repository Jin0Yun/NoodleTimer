import 'package:noodle_timer/domain/entity/user_entity.dart';
import 'package:noodle_timer/domain/enum/noodle_preference.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';

class UserUseCase {
  final UserRepository _userRepository;

  UserUseCase(this._userRepository);

  String? getCurrentUserId() {
    return _userRepository.getCurrentUserId();
  }

  Future<UserEntity?> getCurrentUser() async {
    final userId = getCurrentUserId();
    if (userId == null) return null;
    return await _userRepository.getUserById(userId);
  }

  Future<bool> getNeedsOnboarding() async {
    return await _userRepository.getNeedsOnboarding();
  }

  Future<void> setNeedsOnboarding(bool needsOnboarding) async {
    await _userRepository.setNeedsOnboarding(needsOnboarding);
  }

  Future<void> updateNoodlePreference(
    String userId,
    NoodlePreference preference,
  ) async {
    await _userRepository.updateNoodlePreference(userId, preference);
  }
}