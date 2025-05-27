import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/usecase/cook_history_use_case.dart';
import 'package:noodle_timer/domain/usecase/ramen_usecase.dart';
import 'package:noodle_timer/presentation/viewmodel/history_view_model.dart';
import 'history_view_model_test.mocks.dart';

@GenerateMocks([RamenUseCase, CookHistoryUseCase, AppLogger])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testRamen = RamenEntity(
    id: 100,
    name: '신라면',
    imageUrl: 'https://i.namu.wiki/i/...',
    spicyLevel: '매운맛',
    description: '한국을 대표하는 매운 라면',
    recipe: '1. 물 550ml에...',
    afterSeasoning: false,
    cookTime: 270,
  );

  final testHistory1 = CookHistoryEntity(
    id: 'history-1',
    ramenId: 100,
    ramenName: '신라면',
    ramenImageUrl: 'https://i.namu.wiki/i/...',
    cookedAt: DateTime.now(),
    noodleState: NoodlePreference.kodul,
    eggPreference: EggPreference.none,
    cookTime: Duration(seconds: 270),
  );

  final testHistory2 = CookHistoryEntity(
    id: 'history-2',
    ramenId: 101,
    ramenName: '안성탕면',
    ramenImageUrl: 'https://i.namu.wiki/i/...',
    cookedAt: DateTime.now(),
    noodleState: NoodlePreference.kodul,
    eggPreference: EggPreference.none,
    cookTime: Duration(seconds: 270),
  );

  final testHistories = [testHistory1, testHistory2];

  group('HistoryViewModel 히스토리 로드 테스트', () {
    late MockRamenUseCase mockRamenUseCase;
    late MockCookHistoryUseCase mockCookHistoryUseCase;
    late MockAppLogger mockLogger;
    late HistoryViewModel viewModel;

    setUp(() {
      mockRamenUseCase = MockRamenUseCase();
      mockCookHistoryUseCase = MockCookHistoryUseCase();
      mockLogger = MockAppLogger();
      viewModel = HistoryViewModel(
        mockRamenUseCase,
        mockCookHistoryUseCase,
        mockLogger,
      );
    });

    test('히스토리 로드 성공 시 상태가 업데이트되어야 한다', () async {
      // given
      when(mockCookHistoryUseCase.getCookHistoriesWithRamenInfo())
          .thenAnswer((_) async => testHistories);

      // when
      final result = await viewModel.loadCookHistories();

      // then
      expect(result, true);
      expect(viewModel.state.histories.length, 2);
      expect(viewModel.state.filteredHistories.length, 2);
      expect(viewModel.state.isLoading, false);
    });
  });

  group('HistoryViewModel 검색 기능 테스트', () {
    late MockRamenUseCase mockRamenUseCase;
    late MockCookHistoryUseCase mockCookHistoryUseCase;
    late MockAppLogger mockLogger;
    late HistoryViewModel viewModel;

    setUp(() {
      mockRamenUseCase = MockRamenUseCase();
      mockCookHistoryUseCase = MockCookHistoryUseCase();
      mockLogger = MockAppLogger();
      viewModel = HistoryViewModel(
        mockRamenUseCase,
        mockCookHistoryUseCase,
        mockLogger,
      );
    });

    test('검색어가 없으면 전체 히스토리가 표시되어야 한다', () async {
      // given
      when(mockCookHistoryUseCase.getCookHistoriesWithRamenInfo())
          .thenAnswer((_) async => testHistories);
      await viewModel.loadCookHistories();

      // when
      viewModel.searchHistories('');

      // then
      expect(viewModel.state.filteredHistories.length, 2);
    });

    test('검색어로 히스토리를 필터링할 수 있어야 한다', () async {
      // given
      when(mockCookHistoryUseCase.getCookHistoriesWithRamenInfo())
          .thenAnswer((_) async => testHistories);
      await viewModel.loadCookHistories();

      // when
      viewModel.searchHistories('신라면');

      // then
      expect(viewModel.state.filteredHistories.length, 1);
      expect(viewModel.state.filteredHistories.first.ramenName, '신라면');
    });

    test('부분 검색어로도 히스토리를 찾을 수 있어야 한다', () async {
      // given
      when(mockCookHistoryUseCase.getCookHistoriesWithRamenInfo())
          .thenAnswer((_) async => testHistories);
      await viewModel.loadCookHistories();

      // when
      viewModel.searchHistories('면');

      // then
      expect(viewModel.state.filteredHistories.length, 2);
    });

    test('공백 검색어는 트림되어 처리되어야 한다', () async {
      // given
      when(mockCookHistoryUseCase.getCookHistoriesWithRamenInfo())
          .thenAnswer((_) async => testHistories);
      await viewModel.loadCookHistories();

      // when
      viewModel.searchHistories('  ');

      // then
      expect(viewModel.state.filteredHistories.length, 2);
    });
  });

  group('HistoryViewModel 다시 조리하기 테스트', () {
    late MockRamenUseCase mockRamenUseCase;
    late MockCookHistoryUseCase mockCookHistoryUseCase;
    late MockAppLogger mockLogger;
    late HistoryViewModel viewModel;

    setUp(() {
      mockRamenUseCase = MockRamenUseCase();
      mockCookHistoryUseCase = MockCookHistoryUseCase();
      mockLogger = MockAppLogger();
      viewModel = HistoryViewModel(
        mockRamenUseCase,
        mockCookHistoryUseCase,
        mockLogger,
      );
    });

    test('다시 조리하기 데이터 가져오기 성공 시 히스토리가 반환되어야 한다', () async {
      // given
      when(mockRamenUseCase.getRamenById(100))
          .thenAnswer((_) async => testRamen);

      // when
      final result = await viewModel.getReplayData(testHistory1);

      // then
      expect(result, isNotNull);
      expect(result!.ramenName, '신라면');
    });

    test('라면 정보를 찾을 수 없으면 null이 반환되어야 한다', () async {
      // given
      when(mockRamenUseCase.getRamenById(100))
          .thenAnswer((_) async => null);

      // when
      final result = await viewModel.getReplayData(testHistory1);

      // then
      expect(result, isNull);
      expect(viewModel.state.error, contains('다시 조리하기에 실패했습니다'));
    });

    test('라면 조회 중 예외 발생 시 에러가 설정되어야 한다', () async {
      // given
      when(mockRamenUseCase.getRamenById(100))
          .thenThrow(Exception('네트워크 오류'));

      // when
      final result = await viewModel.getReplayData(testHistory1);

      // then
      expect(result, isNull);
      expect(viewModel.state.error, contains('다시 조리하기에 실패했습니다'));
    });
  });

  group('HistoryViewModel 히스토리 삭제 테스트', () {
    late MockRamenUseCase mockRamenUseCase;
    late MockCookHistoryUseCase mockCookHistoryUseCase;
    late MockAppLogger mockLogger;
    late HistoryViewModel viewModel;

    setUp(() {
      mockRamenUseCase = MockRamenUseCase();
      mockCookHistoryUseCase = MockCookHistoryUseCase();
      mockLogger = MockAppLogger();
      viewModel = HistoryViewModel(
        mockRamenUseCase,
        mockCookHistoryUseCase,
        mockLogger,
      );
    });

    test('히스토리 삭제 성공 시 목록에서 제거되어야 한다', () async {
      // given
      when(mockCookHistoryUseCase.getCookHistoriesWithRamenInfo())
          .thenAnswer((_) async => testHistories);
      await viewModel.loadCookHistories();
      when(mockCookHistoryUseCase.deleteCookHistory('history-1'))
          .thenAnswer((_) async {});

      // when
      final result = await viewModel.deleteHistory('history-1');

      // then
      expect(result, true);
      expect(viewModel.state.histories.length, 1);
      expect(viewModel.state.filteredHistories.length, 1);
      expect(viewModel.state.histories.first.id, 'history-2');
      expect(viewModel.state.isLoading, false);
    });

    test('존재하지 않는 히스토리 삭제 시에도 정상 처리되어야 한다', () async {
      // given
      when(mockCookHistoryUseCase.getCookHistoriesWithRamenInfo())
          .thenAnswer((_) async => testHistories);
      await viewModel.loadCookHistories();
      when(mockCookHistoryUseCase.deleteCookHistory('non-existent'))
          .thenAnswer((_) async {});

      // when
      final result = await viewModel.deleteHistory('non-existent');

      // then
      expect(result, true);
      expect(viewModel.state.histories.length, 2);
      expect(viewModel.state.isLoading, false);
    });
  });
}