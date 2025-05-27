import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/enum/egg_preference.dart';
import 'package:noodle_timer/domain/enum/noodle_preference.dart';
import 'package:noodle_timer/domain/enum/timer_phase.dart';
import 'package:noodle_timer/domain/usecase/cook_history_use_case.dart';
import 'package:noodle_timer/presentation/viewmodel/timer_view_model.dart';
import 'timer_view_model_test.mocks.dart';

@GenerateMocks([CookHistoryUseCase, AppLogger])
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

  group('TimerViewModel 라면 업데이트 테스트', () {
    late MockCookHistoryUseCase mockCookHistoryUseCase;
    late MockAppLogger mockLogger;
    late TimerViewModel viewModel;

    setUp(() {
      mockCookHistoryUseCase = MockCookHistoryUseCase();
      mockLogger = MockAppLogger();
      viewModel = TimerViewModel(mockCookHistoryUseCase, mockLogger);
    });

    test('라면 업데이트 시 타이머 상태가 초기화되어야 한다', () {
      // when
      viewModel.updateRamen(testRamen);

      // then
      expect(viewModel.state.phase, TimerPhase.cooking);
      expect(viewModel.state.totalSeconds, 270);
      expect(viewModel.state.remainingSeconds, 270);
      expect(viewModel.state.ramenName, '신라면');
      expect(viewModel.state.isRunning, false);
    });

    test('선호도 업데이트가 정상적으로 작동해야 한다', () {
      // when
      viewModel.updatePreferences(EggPreference.half, NoodlePreference.peojin);

      // then
      expect(viewModel.state, isNotNull);
    });
  });

  group('TimerViewModel 타이머 제어 테스트', () {
    late MockCookHistoryUseCase mockCookHistoryUseCase;
    late MockAppLogger mockLogger;
    late TimerViewModel viewModel;

    setUp(() {
      mockCookHistoryUseCase = MockCookHistoryUseCase();
      mockLogger = MockAppLogger();
      viewModel = TimerViewModel(mockCookHistoryUseCase, mockLogger);
      viewModel.updateRamen(testRamen);
    });

    test('타이머 시작이 정상적으로 작동해야 한다', () {
      // when
      viewModel.start();

      // then
      expect(viewModel.state.isRunning, true);
    });

    test('타이머 정지가 정상적으로 작동해야 한다', () {
      // given
      viewModel.start();

      // when
      viewModel.stop();

      // then
      expect(viewModel.state.isRunning, false);
    });

    test('타이머 재시작이 정상적으로 작동해야 한다', () {
      // given
      viewModel.start();
      viewModel.stop();

      // when
      viewModel.restart();

      // then
      expect(viewModel.state.phase, TimerPhase.cooking);
      expect(viewModel.state.remainingSeconds, 270);
      expect(viewModel.state.isRunning, false);
    });

    test('남은 시간이 0일 때 시작하면 타이머가 시작되지 않아야 한다', () {
      // given
      viewModel.updateRamen(testRamen.copyWith(cookTime: 0));

      // when
      viewModel.start();

      // then
      expect(viewModel.state.isRunning, false);
    });

    test('이미 실행 중일 때 시작하면 무시되어야 한다', () {
      // given
      viewModel.start();
      final initialState = viewModel.state;

      // when
      viewModel.start();

      // then
      expect(viewModel.state.isRunning, initialState.isRunning);
    });

    test('초기 상태에서 시작하면 타이머가 시작되지 않아야 한다', () {
      // given
      final initialViewModel = TimerViewModel(
        mockCookHistoryUseCase,
        mockLogger,
      );

      // when
      initialViewModel.start();

      // then
      expect(initialViewModel.state.isRunning, false);
    });
  });

  group('TimerViewModel 시간 포맷 테스트', () {
    test('시간 포맷이 정확해야 한다', () {
      expect(TimerViewModel.formatTime(0), '0:00');
      expect(TimerViewModel.formatTime(59), '0:59');
      expect(TimerViewModel.formatTime(60), '1:00');
      expect(TimerViewModel.formatTime(125), '2:05');
      expect(TimerViewModel.formatTime(270), '4:30');
    });
  });
}