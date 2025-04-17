import 'package:firebase_auth/firebase_auth.dart';

enum AuthErrorType {
  emailAlreadyInUse("이미 사용 중인 이메일입니다."),
  invalidEmail("유효하지 않은 이메일 형식입니다."),
  wrongPassword("비밀번호가 일치하지 않습니다."),
  userNotFound("사용자를 찾을 수 없습니다."),
  weakPassword("비밀번호가 너무 약합니다."),
  signOutFailed("로그아웃에 실패했습니다."),
  unknown("알 수 없는 오류가 발생했습니다.");

  final String message;

  const AuthErrorType(this.message);
}

class AuthError implements Exception {
  final AuthErrorType type;
  final String? details;

  const AuthError(this.type, [this.details]);

  String get message => details != null ? "${type.message} $details" : type.message;

  @override
  String toString() => 'AuthError(type: $type, message: $message)';

  factory AuthError.fromFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return AuthError(AuthErrorType.emailAlreadyInUse);
      case 'invalid-email':
        return AuthError(AuthErrorType.invalidEmail);
      case 'wrong-password':
        return AuthError(AuthErrorType.wrongPassword);
      case 'user-not-found':
        return AuthError(AuthErrorType.userNotFound);
      case 'weak-password':
        return AuthError(AuthErrorType.weakPassword);
      default:
        return AuthError(AuthErrorType.unknown, e.message);
    }
  }
}