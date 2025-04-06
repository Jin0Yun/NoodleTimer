import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/exceptions/ramen_error.dart';
import 'package:noodle_timer/data/dto/ramen_data.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_provider.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_view_model.dart';
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

    test('초기 상태는 빈 목록과 로딩 중이어야 한다', () {
      final state = container.read(ramenViewModelProvider);
      expect(state.brands, isEmpty);
      expect(state.currentRamenList, isNull);
      expect(state.isLoading, true);
    });

    test('브랜드 로드 성공 시 정상적으로 업데이트되어야 한다', () async {
      // given
      when(mockRepository.loadBrands())
          .thenAnswer((_) => Future.value(testBrands));
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

    test('브랜드 선택 시 해당 라면 목록이 currentRamenList에 업데이트되어야 한다', () async {
      // given
      when(mockRepository.loadBrands()).thenAnswer((_) async => testBrands);

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

    test('없는 브랜드를 선택하면 brandNotFound 에러가 발생해야 한다', () async {
      // given
      when(mockRepository.loadBrands()).thenAnswer((_) async => testBrands);

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

    test('에셋 로드 실패 시 assetNotFound 에러가 발생해야 한다', () async {
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

    test('파싱 실패 시 parsingError 에러가 발생해야 한다', () async {
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

    test('알 수 없는 예외 발생 시 unknownError 로 처리되어야 한다', () async {
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