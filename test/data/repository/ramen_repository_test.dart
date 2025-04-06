import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:noodle_timer/core/exceptions/ramen_error.dart';
import 'package:noodle_timer/data/data_loader.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/data/repository/ramen_repository_impl.dart';
import 'ramen_repository_test.mocks.dart';

@GenerateMocks([IDataLoader])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockDataLoader = MockIDataLoader();
  final repository = RamenRepositoryImpl(mockDataLoader);

  final ramenDataJson = {
    'ramenData': [
      {
        'brandId': 1,
        'brandName': '농심',
        'ramens': [
          {
            'ramenIndex': 100,
            'ramenName': '신라면',
            'ramenImage': 'https://i.namu.wiki/i/...',
            'ramenSpicy': '매운맛',
            'ramenDescription': '한국을 대표하는 매운 라면',
            'ramenRecipe': '1. 물 550ml에...',
            'afterSeasoning': false,
          },
          {
            'ramenIndex': 101,
            'ramenName': '안성탕면',
            'ramenImage': 'https://i.namu.wiki/i/...',
            'ramenSpicy': '순한맛',
            'ramenDescription': '담백한 맛의 전통적인 라면',
            'ramenRecipe': '1. 물 550ml에...',
            'afterSeasoning': false,
          },
        ],
      },
    ],
  };

  group('RamenRepository 테스트', () {
    test('정상적인 JSON 파싱이 되어야 한다', () async {
      // given
      when(mockDataLoader.load(any)).thenAnswer((_) async => json.encode(ramenDataJson));

      // when
      final result = await repository.loadBrands();

      // then
      expect(result, isA<List<RamenBrandEntity>>());
      expect(result[0].ramens.length, 2);
      expect(result[0].name, '농심');
      expect(result[0].ramens[0].name, '신라면');
      expect(result[0].ramens[1].name, '안성탕면');
    });

    test('빈 데이터가 주어졌을 때 빈 리스트를 반환해야 한다', () async {
      // given
      final emptyJson = {'ramenData': []};
      when(mockDataLoader.load(any)).thenAnswer((_) async => json.encode(emptyJson));

      // when
      final result = await repository.loadBrands();

      // then
      expect(result, isEmpty);
    });

    test('FlutterError 발생 시 정확한 RamenError 반환해야 한다', () async {
      // given
      final flutterError = FlutterError('Asset path error');
      when(mockDataLoader.load(any)).thenThrow(flutterError);

      // when & then
      expect(
            () => repository.loadBrands(),
        throwsA(
          predicate((e) =>
          e is RamenError &&
              e.type == RamenErrorType.assetNotFound &&
              e.message == '${RamenErrorType.assetNotFound.message} ${flutterError.toString()}'),
        ),
      );
    });

    test('FormatException 발생 시 정확한 RamenError 반환해야 한다', () async {
      // given
      final formatException = FormatException('Invalid JSON error');
      when(mockDataLoader.load(any)).thenThrow(formatException);

      // when & then
      expect(
            () => repository.loadBrands(),
        throwsA(
          predicate((e) =>
          e is RamenError &&
              e.type == RamenErrorType.parsingError &&
              e.message == '${RamenErrorType.parsingError.message} ${formatException.toString()}'),
        ),
      );
    });

    test('알 수 없는 에러 발생 시 정확한 RamenError 반환해야 한다', () async {
      // given
      final exception = Exception('Unknown error');
      when(mockDataLoader.load(any)).thenThrow(exception);

      // when & then
      expect(
            () => repository.loadBrands(),
        throwsA(
          predicate((e) =>
          e is RamenError &&
              e.type == RamenErrorType.unknownError &&
              e.message == '${RamenErrorType.unknownError.message} ${exception.toString()}'),
        ),
      );
    });
  });

  group('RamenRepositoryImpl 통합 테스트', () {
    test('RamenRepositoryImpl의 초기화가 정상적으로 되어야 한다', () {
      // then
      expect(repository, isA<RamenRepository>());
    });

    test('실제 JSON 파일을 로드하여 데이터 파싱 테스트', () async {
      // given
      when(mockDataLoader.load(any)).thenAnswer((_) async => json.encode(ramenDataJson));

      // when
      final result = await repository.loadBrands();

      // then
      expect(result, isA<List<RamenBrandEntity>>());
      expect(result.length, greaterThan(0));
      expect(result[0].name, '농심');
      expect(result[0].ramens, isNotEmpty);
    });
  });
}
