import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum RamenErrorType {
  assetNotFound("에셋을 찾을 수 없습니다."),
  brandNotFound("브랜드 데이터를 찾을 수 없습니다."),
  ramenNotFound("해당 라면을 찾을 수 없습니다."),
  parsingError("JSON 파싱에 실패했습니다."),
  networkError("네트워크 연결에 문제가 있습니다."),
  unknown("알 수 없는 오류가 발생했습니다.");

  final String message;
  const RamenErrorType(this.message);
}

class RamenException implements Exception {
  final RamenErrorType type;
  final String? details;

  const RamenException(this.type, [this.details]);

  @override
  String toString() =>
      details != null ? "${type.message} $details" : type.message;

  factory RamenException.fromException(dynamic e) {
    if (e is PlatformException || e is FlutterError) {
      return RamenException(RamenErrorType.assetNotFound);
    } else if (e is FormatException) {
      return RamenException(RamenErrorType.parsingError);
    } else if (e is StateError) {
      return RamenException(RamenErrorType.ramenNotFound);
    } else if (e is SocketException || e is TimeoutException) {
      return RamenException(RamenErrorType.networkError);
    } else {
      return RamenException(RamenErrorType.unknown);
    }
  }
}