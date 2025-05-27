import 'package:firebase_auth/firebase_auth.dart';
import 'package:noodle_timer/core/exceptions/auth_exception.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final AppLogger _logger;

  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required AppLogger logger,
  }) : _firebaseAuth = firebaseAuth,
        _logger = logger;

  @override
  Future<UserCredential> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('회원가입 성공: $email');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _logger.e('회원가입 실패: $email', e);
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      _logger.e('회원가입 중 알 수 없는 오류 발생', e);
      throw AuthException(AuthErrorType.unknown, e.toString());
    }
  }

  @override
  Future<UserCredential> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('로그인 성공: $email');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _logger.e('로그인 실패: $email', e);
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      _logger.e('로그인 중 알 수 없는 오류 발생', e);
      throw AuthException(AuthErrorType.unknown, e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _logger.i('로그아웃 성공');
    } catch (e) {
      _logger.e('로그아웃 실패', e);
      throw AuthException(AuthErrorType.signOutFailed, e.toString());
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthException(AuthErrorType.userNotFound, '로그인된 사용자가 없습니다');
      }

      await user.delete();
      _logger.i('계정 삭제 성공: ${user.email}');
    } on FirebaseAuthException catch (e) {
      _logger.e('계정 삭제 실패', e);
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      _logger.e('계정 삭제 중 알 수 없는 오류 발생', e);
      throw AuthException(AuthErrorType.unknown, e.toString());
    }
  }

  @override
  Future<void> reauthenticateWithPassword(String password) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || user.email == null) {
        throw AuthException(AuthErrorType.userNotFound, '로그인된 사용자가 없습니다');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      _logger.i('재인증 성공: ${user.email}');
    } on FirebaseAuthException catch (e) {
      _logger.e('재인증 실패', e);
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      _logger.e('재인증 중 알 수 없는 오류 발생', e);
      throw AuthException(AuthErrorType.unknown, e.toString());
    }
  }

  @override
  Future<void> deleteAccountWithReauth(String password) async {
    await reauthenticateWithPassword(password);
    await deleteAccount();
  }
}