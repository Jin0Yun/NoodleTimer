import 'package:flutter_test/flutter_test.dart';
import 'package:noodle_timer/data/dto/ramen.dart';
import 'package:noodle_timer/data/dto/ramen_brand.dart';
import 'package:noodle_timer/data/dto/ramen_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('모델 JSON 파싱 테스트', () {
    test('Ramen 모델에서 JSON을 정상적으로 파싱할 수 있어야 한다', () {
      // given
      final ramenJson = {
        'ramenIndex': 100,
        'ramenName': '신라면',
        'ramenImage': 'https://i.namu.wiki/i/...',
        'ramenSpicy': '매운맛',
        'ramenDescription': '한국을 대표하는 매운 라면',
        'ramenRecipe': '1. 물 550ml에...',
        'afterSeasoning': false,
      };

      // when
      final ramen = Ramen.fromJson(ramenJson);

      // then
      expect(ramen.id, 100);
      expect(ramen.name, '신라면');
      expect(ramen.imageUrl, 'https://i.namu.wiki/i/...');
      expect(ramen.spicyLevel, '매운맛');
      expect(ramen.description, '한국을 대표하는 매운 라면');
      expect(ramen.recipe, '1. 물 550ml에...');
      expect(ramen.afterSeasoning, false);
    });

    test('RamenBrand 모델에서 라면 리스트를 포함한 JSON을 파싱할 수 있어야 한다', () {
      // given
      final brandJson = {
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
        ],
      };

      // when
      final brand = RamenBrand.fromJson(brandJson);

      // then
      expect(brand.id, 1);
      expect(brand.name, '농심');
      expect(brand.ramens.length, 1);
      expect(brand.ramens[0].name, '신라면');
    });

    test('RamenData 모델에서 전체 ramenData 구조를 파싱할 수 있어야 한다', () {
      // given
      final dataJson = {
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
            ],
          },
        ],
      };

      // when
      final data = RamenData.fromJson(dataJson);

      // then
      expect(data.brands.length, 1);
      expect(data.brands[0].name, '농심');
      expect(data.brands[0].ramens.length, 1);
      expect(data.brands[0].ramens[0].name, '신라면');
    });

    test('ramenData 필드가 빈 리스트일 때, 파싱 결과도 빈 리스트여야 한다', () {
      // given
      final emptyDataJson = {'ramenData': []};

      // when
      final data = RamenData.fromJson(emptyDataJson);

      // then
      expect(data.brands, isEmpty);
    });

    test('Ramen JSON에서 필드가 누락되면 예외가 발생해야 한다', () {
      // given
      final brokenJson = {
        'ramenIndex': 101,
        'ramenName': '라면왕김통깨',
        // 'ramenImage' 누락
        'ramenSpicy': '중간맛',
        'ramenDescription': '간장베이스의 라면',
        'ramenRecipe': '1. 물 500ml에...',
        'afterSeasoning': true,
      };

      // when & then
      expect(() => Ramen.fromJson(brokenJson), throwsA(isA<TypeError>()));
    });
  });

  group('모델 → 엔티티 변환 테스트', () {
    test('Ramen 모델에서 Entity로 정상적으로 변환되어야 한다', () {
      // given
      final ramenJson = {
        'ramenIndex': 100,
        'ramenName': '신라면',
        'ramenImage': 'https://i.namu.wiki/i/...',
        'ramenSpicy': '매운맛',
        'ramenDescription': '한국을 대표하는 매운 라면',
        'ramenRecipe': '1. 물 550ml에...',
        'afterSeasoning': false,
      };
      final ramen = Ramen.fromJson(ramenJson);

      // when
      final entity = ramen.toEntity();

      // then
      expect(entity.name, '신라면');
      expect(entity.afterSeasoning, false);
    });

    test('RamenBrand 모델에서 Entity로 정상적으로 변환되어야 한다', () {
      // given
      final brandJson = {
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
        ],
      };
      final brand = RamenBrand.fromJson(brandJson);

      // when
      final entity = brand.toEntity();

      // then
      expect(entity.id, 1);
      expect(entity.name, '농심');
      expect(entity.ramens.first.name, '신라면');
    });

    test('RamenData 모델에서 Entity로 정상적으로 변환되어야 한다', () {
      // given
      final dataJson = {
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
            ],
          },
        ],
      };
      final data = RamenData.fromJson(dataJson);

      // when
      final entity = data.toEntity();

      // then
      expect(entity.brands.length, 1);
      expect(entity.brands.first.name, '농심');
      expect(entity.brands.first.ramens.first.name, '신라면');
    });
  });
}
