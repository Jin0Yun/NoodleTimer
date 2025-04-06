import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/exceptions/ramen_error.dart';
import 'package:noodle_timer/viewmodel/provider.dart';
import 'package:noodle_timer/model/ramen_data.dart';
import 'package:noodle_timer/repository/ramen_repository.dart';
import 'package:noodle_timer/viewmodel/ramen_view_model.dart';
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
  final testRamenData = RamenData.fromJson(ramenDataJson);

  group('RamenViewModel 테스트', () {
    late MockRamenRepository mockRepository;
    late RamenViewModel viewModel;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockRamenRepository();
      container = ProviderContainer(
        overrides: [
          ramenRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      viewModel = RamenViewModel(mockRepository);
      when(mockRepository.loadBrands()).thenAnswer((_) async => []);
      addTearDown(() => container.dispose());
    });

    test('초기 상태는 빈 목록과 로딩 중 상태', () {
      final state = container.read(ramenViewModelProvider);
      expect(state.brands, isEmpty);
      expect(state.currentRamenList, isNull);
      expect(state.isLoading, true);
    });

    test('브랜드 목록 로드 성공', () async {
      // given
      when(mockRepository.loadBrands())
          .thenAnswer((_) => Future.value(testRamenData.brands));
      final viewModel = container.read(ramenViewModelProvider.notifier);

      // when
      await viewModel.loadBrands();

      // then
      final state = container.read(ramenViewModelProvider);
      expect(state.brands.length, 2);
      expect(state.brands[0].name, '나의 라면 기록');
      expect(state.currentRamenList, isNull);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('브랜드 선택 시 라면 목록 업데이트', () async {
      // given
      when(mockRepository.loadBrands()).thenAnswer((_) async => testRamenData.brands);

      final viewModel = container.read(ramenViewModelProvider.notifier);
      await viewModel.loadBrands();

      // when
      viewModel.selectBrand(1);

      // then
      final state = container.read(ramenViewModelProvider);
      expect(state.currentRamenList, isNotNull);
      expect(state.currentRamenList!.length, 2);
      expect(state.currentRamenList![0].name, '신라면');
      expect(state.currentRamenList![1].name, '안성탕면');
      expect(state.error, isNull);
    });

    test('존재하지 않는 브랜드 선택 시 에러 반환', () async {
      // given
      when(mockRepository.loadBrands()).thenAnswer((_) async => testRamenData.brands);

      final viewModel = container.read(ramenViewModelProvider.notifier);
      await viewModel.loadBrands();

      // when
      viewModel.selectBrand(999);

      // then
      final state = container.read(ramenViewModelProvider);
      expect(state.error, isNotNull);
      expect(state.error!.type, RamenErrorType.brandNotFound);
      expect(state.error!.details, contains('999'));
      expect(state.errorMessage, contains('브랜드 데이터를 찾을 수 없습니다'));
    });

    test('브랜드 로드 실패 처리 - 에셋 없음', () async {
      // given
      when(mockRepository.loadBrands())
          .thenThrow(RamenError(RamenErrorType.assetNotFound));

      // when
      final viewModel = container.read(ramenViewModelProvider.notifier);
      await viewModel.loadBrands();

      // then
      final state = container.read(ramenViewModelProvider);
      expect(state.error, isNotNull);
      expect(state.error!.type, RamenErrorType.assetNotFound);
      expect(state.isLoading, false);
    });

    test('브랜드 로드 실패 처리 - 파싱 에러', () async {
      // given
      when(mockRepository.loadBrands())
          .thenThrow(RamenError(RamenErrorType.parsingError, 'JSON 구문 오류'));

      // when
      final viewModel = container.read(ramenViewModelProvider.notifier);
      await viewModel.loadBrands();

      // then
      final state = container.read(ramenViewModelProvider);
      expect(state.error, isNotNull);
      expect(state.error!.type, RamenErrorType.parsingError);
      expect(state.error!.details, 'JSON 구문 오류');
      expect(state.errorMessage, contains('JSON 파싱에 실패했습니다'));
      expect(state.isLoading, false);
    });

    test('일반 예외 발생 시 unknownError로 변환', () async {
      // given
      when(mockRepository.loadBrands())
          .thenThrow(Exception('테스트 예외'));

      // when
      final viewModel = container.read(ramenViewModelProvider.notifier);
      await viewModel.loadBrands();

      // then
      final state = container.read(ramenViewModelProvider);
      expect(state.error, isNotNull);
      expect(state.error!.type, RamenErrorType.unknownError);
      expect(state.error!.details, contains('테스트 예외'));
      expect(state.isLoading, false);
    });
  });
}