import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';

class UserUseCase {
  final UserRepository _userRepository;

  UserUseCase(this._userRepository);

  String? getCurrentUserId() {
    return _userRepository.getCurrentUserId();
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