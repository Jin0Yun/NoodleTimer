import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/user_entity.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';
import 'package:noodle_timer/domain/repository/user_repository.dart';
import 'package:noodle_timer/core/exceptions/auth_exception.dart';

class AuthUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthUseCase(this._authRepository, this._userRepository);

  Future<void> login(String email, String password) async {
    await _authRepository.signIn(email, password);
  }

  Future<void> signUp(String email, String password) async {
    final userCredential = await _authRepository.signUp(email.trim(), password);

    final user = userCredential.user;
    if (user == null) {
      throw AuthException(AuthErrorType.unknown, '사용자 생성 실패');
    }

    final userEntity = UserEntity(
      uid: user.uid,
      email: email.trim(),
      favoriteRamenIds: [],
      noodlePreference: NoodlePreference.none,
      eggPreference: EggPreference.none,
      createdAt: DateTime.now(),
    );
    await _userRepository.saveUser(userEntity);
  }

  Future<void> logout() async {
    await _authRepository.signOut();
  }
}