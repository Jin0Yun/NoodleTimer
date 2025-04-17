enum UserErrorType {
  userNotFound("사용자를 찾을 수 없습니다."),
  updateFailed("사용자 정보 업데이트에 실패했습니다."),
  saveFailed("데이터 저장에 실패했습니다."),
  loadFailed("데이터 불러오기에 실패했습니다."),
  unknown("알 수 없는 오류가 발생했습니다.");

  final String message;

  const UserErrorType(this.message);
}

class UserError implements Exception {
  final UserErrorType type;
  final String? details;

  const UserError(this.type, [this.details]);

  String get message => details != null ? "${type.message} $details" : type.message;

  @override
  String toString() => 'UserError(type: $type, message: $message)';
}