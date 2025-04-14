import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/di/app_providers.dart';
import 'package:noodle_timer/data/dto/ramen_data.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'search_view_model_test.mocks.dart';

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

  final testRamenList = RamenData.fromJson(ramenDataJson)
      .toEntity()
      .brands
      .expand((brand) => brand.ramens)
      .toList();

  group('SearchViewModel 테스트', () {
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

    test('초기 상태에서 allRamen은 비어 있지 않아야 한다', () async {
      // given
      when(mockRepository.loadAllRamen()).thenAnswer((_) async => testRamenList);
      final viewModel = container.read(searchViewModelProvider.notifier);

      // when
      await viewModel.loadRames();

      // then
      final state = container.read(searchViewModelProvider);
      expect(state.allRamen, isNotEmpty);
    });

    test('검색어가 없으면 전체 라면 목록과 동일한 결과를 반환해야 한다', () async {
      // given
      when(mockRepository.loadAllRamen()).thenAnswer((_) async => testRamenList);
      final viewModel = container.read(searchViewModelProvider.notifier);

      // when
      await viewModel.loadRames();
      viewModel.updateSearchKeyword('');

      // then
      final state = container.read(searchViewModelProvider);
      expect(state.searchResults, equals(testRamenList));
    });

    test('검색어가 주어졌을 때 해당 라면만 필터링되어야 한다', () async {
      // given
      when(mockRepository.loadAllRamen()).thenAnswer((_) async => testRamenList);
      final viewModel = container.read(searchViewModelProvider.notifier);

      // when
      await viewModel.loadRames();
      viewModel.updateSearchKeyword('신라면');

      // then
      final state = container.read(searchViewModelProvider);
      expect(state.searchResults.length, 1);
      expect(state.searchResults.first.name, '신라면');
    });

    test('resetSearch 호출 시 검색어와 결과가 초기화되어야 한다', () async {
      // given
      when(mockRepository.loadAllRamen()).thenAnswer((_) async => testRamenList);
      final viewModel = container.read(searchViewModelProvider.notifier);

      // when
      await viewModel.loadRames();
      viewModel.resetSearch();
      viewModel.updateSearchKeyword('신라면');

      // then
      final state = container.read(searchViewModelProvider);
      expect(state.searchKeyword, isEmpty);
      expect(state.searchResults, isEmpty);
    });
  });
}
