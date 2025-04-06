enum RamenErrorType {
  assetNotFound("에셋을 찾을 수 없습니다."),
  brandNotFound("브랜드 데이터를 찾을 수 없습니다."),
  parsingError("JSON 파싱에 실패했습니다."),
  networkError("네트워크 연결에 문제가 있습니다."),
  unknownError("알 수 없는 오류가 발생했습니다.");

  final String message;

  const RamenErrorType(this.message);
}

class RamenError implements Exception {
  final RamenErrorType type;
  final String? details;

  const RamenError(this.type, [this.details]);

  String get message => details != null ? "${type.message} $details" : type.message;

  @override
  String toString() => 'RamenError(type: $type, message: $message)';
}