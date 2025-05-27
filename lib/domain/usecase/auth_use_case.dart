import 'package:firebase_auth/firebase_auth.dart';
import 'package:noodle_timer/domain/enum/egg_preference.dart';
import 'package:noodle_timer/domain/entity/user_entity.dart';
import 'package:noodle_timer/domain/enum/noodle_preference.dart';
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

  Future<void> deleteAccount() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await _userRepository.deleteAllUserData(currentUser.uid);
    }

    await _authRepository.deleteAccount();
  }

  Future<void> deleteAccountWithPassword(String password) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw AuthException(AuthErrorType.userNotFound, '로그인된 사용자가 없습니다');
    }

    final uid = currentUser.uid;

    try {
      await _authRepository.deleteAccountWithReauth(password);
      await _userRepository.deleteAllUserData(uid);
    } catch (e) {
      rethrow;
    }
  }
}