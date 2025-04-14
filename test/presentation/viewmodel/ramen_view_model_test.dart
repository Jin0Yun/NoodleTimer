import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/data/dto/ramen_data.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'ramen_view_model_test.mocks.dart';

@GenerateMocks([RamenRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
          }
        ]
      }
    ]
  };
  final testBrands = RamenData.fromJson(ramenDataJson).toEntity().brands;

  group('RamenViewModel 테스트', () {
    late MockRamenRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockRamenRepository();
      container = ProviderContainer(
        overrides: [
          ramenRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('브랜드 로드 시 "나의 라면 기록"이 가장 먼저 추가되어야 한다', () async {
      // given
      when(mockRepository.loadBrands()).thenAnswer((_) async => testBrands);
      final viewModel = container.read(ramenViewModelProvider.notifier);

      // when
      await viewModel.loadBrands();

      // then
      final state = container.read(ramenViewModelProvider);
      expect(state.brands.length, 2);
      expect(state.brands[0].name, '나의 라면 기록');
    });

    test('브랜드 선택 전에는 currentRamenList가 null이어야 한다', () async {
      // given
      when(mockRepository.loadBrands()).thenAnswer((_) async => testBrands);
      final viewModel = container.read(ramenViewModelProvider.notifier);

      // when
      await viewModel.loadBrands();

      // then
      final state = container.read(ramenViewModelProvider);
      expect(state.currentRamenList, isNull);
    });

    test('브랜드 선택 시 해당 라면 목록이 currentRamenList에 업데이트되어야 한다', () async {
      // given
      when(mockRepository.loadBrands()).thenAnswer((_) async => testBrands);
      final viewModel = container.read(ramenViewModelProvider.notifier);

      // when
      await viewModel.loadBrands();

      // then
      viewModel.selectBrand(1);
      final state = container.read(ramenViewModelProvider);
      expect(state.currentRamenList, isNotNull);
      expect(state.currentRamenList!.length, 2);
      expect(state.currentRamenList![0].name, '신라면');
      expect(state.currentRamenList![1].name, '안성탕면');
    });
  });
}
