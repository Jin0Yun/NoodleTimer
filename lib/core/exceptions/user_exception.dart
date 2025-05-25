import 'package:firebase_core/firebase_core.dart';

enum UserErrorType {
  userNotFound("사용자를 찾을 수 없습니다."),
  updateFailed("사용자 정보 업데이트에 실패했습니다."),
  saveFailed("데이터 저장에 실패했습니다."),
  loadFailed("데이터 불러오기에 실패했습니다."),
  deleteFailed("삭제에 실패했습니다."),
  permissionDenied("권한이 없습니다."),
  networkError("네트워크 연결을 확인해주세요."),
  unknown("알 수 없는 오류가 발생했습니다.");

  final String message;
  const UserErrorType(this.message);
}

class UserException implements Exception {
  final UserErrorType type;
  final String? details;

  const UserException(this.type, [this.details]);

  @override
  String toString() =>
      details != null ? "${type.message} $details" : type.message;

  factory UserException.fromFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'not-found':
        return UserException(UserErrorType.userNotFound);
      case 'permission-denied':
        return UserException(UserErrorType.permissionDenied);
      case 'unavailable':
      case 'deadline-exceeded':
        return UserException(UserErrorType.networkError);
      case 'failed-precondition':
        return UserException(UserErrorType.updateFailed);
      default:
        return UserException(UserErrorType.unknown);
    }
  }

  factory UserException.fromException(Exception e) {
    if (e is FirebaseException) {
      return UserException.fromFirebaseException(e);
    }
    return UserException(UserErrorType.unknown);
  }
}