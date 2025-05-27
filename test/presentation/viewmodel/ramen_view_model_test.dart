import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/data/dto/ramen_data.dart';
import 'package:noodle_timer/domain/usecase/cook_history_use_case.dart';
import 'package:noodle_timer/domain/usecase/ramen_usecase.dart';
import 'package:noodle_timer/presentation/viewmodel/ramen_view_model.dart';

import 'ramen_view_model_test.mocks.dart';

@GenerateMocks([RamenUseCase, CookHistoryUseCase, AppLogger])
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
            'cookTime': 270,
          },
          {
            'ramenIndex': 101,
            'ramenName': '안성탕면',
            'ramenImage': 'https://i.namu.wiki/i/...',
            'ramenSpicy': '순한맛',
            'ramenDescription': '담백한 맛의 전통적인 라면',
            'ramenRecipe': '1. 물 550ml에...',
            'afterSeasoning': false,
            'cookTime': 270,
          },
        ],
      },
    ],
  };

  final testBrands = RamenData.fromJson(ramenDataJson).toEntity().brands;
  final testRamenList = testBrands.expand((brand) => brand.ramens).toList();

  group('RamenViewModel 브랜드 관리 테스트', () {
    late MockRamenUseCase mockRamenUseCase;
    late MockCookHistoryUseCase mockCookHistoryUseCase;
    late MockAppLogger mockLogger;
    late RamenViewModel viewModel;

    setUp(() {
      mockRamenUseCase = MockRamenUseCase();
      mockCookHistoryUseCase = MockCookHistoryUseCase();
      mockLogger = MockAppLogger();
      viewModel = RamenViewModel(
        mockRamenUseCase,
        mockCookHistoryUseCase,
        mockLogger,
      );
    });

    test('브랜드 로드 시 "나의 라면 기록"이 가장 먼저 추가되어야 한다', () async {
      // given
      when(mockRamenUseCase.loadBrands()).thenAnswer((_) async => testBrands);
      when(
        mockCookHistoryUseCase.getRamenHistoryList(),
      ).thenAnswer((_) async => []);

      // when
      final result = await viewModel.initialize();

      // then
      expect(result, true);
      expect(viewModel.state.brands.length, 2);
      expect(viewModel.state.brands[0].name, '나의 라면 기록');
    });

    test('브랜드 선택 시 해당 라면 목록이 currentRamenList에 업데이트되어야 한다', () async {
      // given
      when(mockRamenUseCase.loadBrands()).thenAnswer((_) async => testBrands);
      when(
        mockCookHistoryUseCase.getRamenHistoryList(),
      ).thenAnswer((_) async => []);
      await viewModel.initialize();

      // when
      viewModel.selectBrand(1);

      // then
      expect(viewModel.state.currentRamenList, isNotEmpty);
      expect(viewModel.state.currentRamenList.length, 2);
      expect(viewModel.state.currentRamenList[0].name, '신라면');
      expect(viewModel.state.currentRamenList[1].name, '안성탕면');
    });
  });

  group('RamenViewModel 검색 기능 테스트', () {
    late MockRamenUseCase mockRamenUseCase;
    late MockCookHistoryUseCase mockCookHistoryUseCase;
    late MockAppLogger mockLogger;
    late RamenViewModel viewModel;

    setUp(() {
      mockRamenUseCase = MockRamenUseCase();
      mockCookHistoryUseCase = MockCookHistoryUseCase();
      mockLogger = MockAppLogger();
      viewModel = RamenViewModel(
        mockRamenUseCase,
        mockCookHistoryUseCase,
        mockLogger,
      );
    });

    test('초기 상태에서 allRamen이 로드되어야 한다', () async {
      // given
      when(mockRamenUseCase.loadBrands()).thenAnswer((_) async => testBrands);
      when(
        mockCookHistoryUseCase.getRamenHistoryList(),
      ).thenAnswer((_) async => []);

      // when
      final result = await viewModel.initialize();

      // then
      expect(result, true);
      expect(viewModel.state.allRamen, isNotEmpty);
      expect(viewModel.state.allRamen.length, 2);
    });

    test('검색어가 없으면 searchResults가 비어있어야 한다', () async {
      // given
      when(mockRamenUseCase.loadBrands()).thenAnswer((_) async => testBrands);
      when(
        mockCookHistoryUseCase.getRamenHistoryList(),
      ).thenAnswer((_) async => []);
      await viewModel.initialize();

      // when
      await viewModel.updateSearchKeyword('');

      // then
      expect(viewModel.state.searchKeyword, isEmpty);
      expect(viewModel.state.searchResults, isEmpty);
    });

    test('검색어가 주어졌을 때 해당 라면만 필터링되어야 한다', () async {
      // given
      when(mockRamenUseCase.loadBrands()).thenAnswer((_) async => testBrands);
      when(
        mockCookHistoryUseCase.getRamenHistoryList(),
      ).thenAnswer((_) async => []);
      when(mockRamenUseCase.searchRamen('신라면', any)).thenAnswer(
        (_) async =>
            testRamenList.where((r) => r.name.contains('신라면')).toList(),
      );
      await viewModel.initialize();

      // when
      await viewModel.updateSearchKeyword('신라면');

      // then
      expect(viewModel.state.searchKeyword, '신라면');
      expect(viewModel.state.searchResults.length, 1);
      expect(viewModel.state.searchResults.first.name, '신라면');
    });

    test('부분 검색어로도 라면을 찾을 수 있어야 한다', () async {
      // given
      when(mockRamenUseCase.loadBrands()).thenAnswer((_) async => testBrands);
      when(
        mockCookHistoryUseCase.getRamenHistoryList(),
      ).thenAnswer((_) async => []);
      when(mockRamenUseCase.searchRamen('면', any)).thenAnswer(
        (_) async => testRamenList.where((r) => r.name.contains('면')).toList(),
      );
      await viewModel.initialize();

      // when
      await viewModel.updateSearchKeyword('면');

      // then
      expect(viewModel.state.searchResults.length, 2);
      expect(
        viewModel.state.searchResults.any((ramen) => ramen.name.contains('면')),
        true,
      );
    });

    test('검색어를 지우면 검색 결과가 초기화되어야 한다', () async {
      // given
      when(mockRamenUseCase.loadBrands()).thenAnswer((_) async => testBrands);
      when(
        mockCookHistoryUseCase.getRamenHistoryList(),
      ).thenAnswer((_) async => []);
      when(mockRamenUseCase.searchRamen('신라면', any)).thenAnswer(
        (_) async =>
            testRamenList.where((r) => r.name.contains('신라면')).toList(),
      );
      await viewModel.initialize();
      await viewModel.updateSearchKeyword('신라면');

      // when
      await viewModel.updateSearchKeyword('');

      // then
      expect(viewModel.state.searchKeyword, isEmpty);
      expect(viewModel.state.searchResults, isEmpty);
    });
  });
}