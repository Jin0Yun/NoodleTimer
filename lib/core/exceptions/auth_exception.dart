import 'package:firebase_auth/firebase_auth.dart';

enum AuthErrorType {
  emailAlreadyInUse("이미 사용 중인 이메일입니다."),
  invalidEmail("유효하지 않은 이메일 형식입니다."),
  wrongPassword("비밀번호가 일치하지 않습니다."),
  userNotFound("사용자를 찾을 수 없습니다."),
  weakPassword("비밀번호가 너무 약합니다."),
  signOutFailed("로그아웃에 실패했습니다."),
  invalidCredential("이메일 또는 비밀번호가 잘못되었습니다."),
  userDisabled("비활성화된 계정입니다."),
  tooManyRequests("너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요."),
  unknown("알 수 없는 오류가 발생했습니다.");

  final String message;
  const AuthErrorType(this.message);
}

class AuthException implements Exception {
  final AuthErrorType type;
  final String? details;

  const AuthException(this.type, [this.details]);

  @override
  String toString() =>
      details != null ? "${type.message} $details" : type.message;

  factory AuthException.fromFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return AuthException(AuthErrorType.emailAlreadyInUse);
      case 'invalid-email':
        return AuthException(AuthErrorType.invalidEmail);
      case 'wrong-password':
        return AuthException(AuthErrorType.wrongPassword);
      case 'user-not-found':
        return AuthException(AuthErrorType.userNotFound);
      case 'weak-password':
        return AuthException(AuthErrorType.weakPassword);
      case 'invalid-credential':
        return AuthException(AuthErrorType.invalidCredential);
      case 'user-disabled':
        return AuthException(AuthErrorType.userDisabled);
      case 'too-many-requests':
        return AuthException(AuthErrorType.tooManyRequests);
      default:
        return AuthException(AuthErrorType.unknown);
    }
  }
}