import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/enum/egg_preference.dart';
import 'package:noodle_timer/domain/entity/user_entity.dart';
import 'package:noodle_timer/domain/enum/noodle_preference.dart';
import 'package:noodle_timer/domain/usecase/user_use_case.dart';
import 'package:noodle_timer/presentation/viewmodel/option_view_model.dart';
import 'option_view_model_test.mocks.dart';

@GenerateMocks([UserUseCase, AppLogger])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testUser = UserEntity(
    uid: 'test-user-id',
    email: 'test@example.com',
    favoriteRamenIds: [],
    noodlePreference: NoodlePreference.kodul,
    eggPreference: EggPreference.half,
    createdAt: DateTime.now(),
  );

  group('OptionViewModel 설정 업데이트 테스트', () {
    late MockUserUseCase mockUserUseCase;
    late MockAppLogger mockLogger;
    late OptionViewModel viewModel;

    setUp(() {
      mockUserUseCase = MockUserUseCase();
      mockLogger = MockAppLogger();
      viewModel = OptionViewModel(mockUserUseCase, mockLogger);
    });

    test('계란 선호도 업데이트가 정상적으로 작동해야 한다', () {
      // when
      viewModel.updateEggPreference(EggPreference.full);

      // then
      expect(viewModel.state.eggPreference, EggPreference.full);
    });

    test('면 선호도 업데이트가 정상적으로 작동해야 한다', () {
      // when
      viewModel.updateNoodlePreference(NoodlePreference.peojin);

      // then
      expect(viewModel.state.noodlePreference, NoodlePreference.peojin);
    });

    test('라벨로 계란 선호도 업데이트가 정상적으로 작동해야 한다', () {
      // when
      viewModel.updateEggPreferenceFromLabel('반숙');

      // then
      expect(viewModel.state.eggPreference, EggPreference.half);
    });

    test('잘못된 라벨로 계란 선호도 업데이트 시 기본값이 설정되어야 한다', () {
      // when
      viewModel.updateEggPreferenceFromLabel('잘못된값');

      // then
      expect(viewModel.state.eggPreference, EggPreference.none);
    });

    test('라벨로 면 선호도 업데이트가 정상적으로 작동해야 한다', () {
      // when
      viewModel.updateNoodlePreferenceFromLabel('퍼진면');

      // then
      expect(viewModel.state.noodlePreference, NoodlePreference.peojin);
    });

    test('잘못된 라벨로 면 선호도 업데이트 시 기본값이 설정되어야 한다', () {
      // when
      viewModel.updateNoodlePreferenceFromLabel('잘못된값');

      // then
      expect(viewModel.state.noodlePreference, NoodlePreference.kodul);
    });
  });

  group('OptionViewModel 사용자 설정 로드 테스트', () {
    late MockUserUseCase mockUserUseCase;
    late MockAppLogger mockLogger;
    late OptionViewModel viewModel;

    setUp(() {
      mockUserUseCase = MockUserUseCase();
      mockLogger = MockAppLogger();
      viewModel = OptionViewModel(mockUserUseCase, mockLogger);
    });

    test('사용자 설정 로드 성공 시 상태가 업데이트되어야 한다', () async {
      // given
      when(mockUserUseCase.getCurrentUser())
          .thenAnswer((_) async => testUser);

      // when
      await viewModel.loadUserPreferences();

      // then
      expect(viewModel.state.noodlePreference, NoodlePreference.kodul);
      expect(viewModel.state.eggPreference, EggPreference.half);
      expect(viewModel.state.isLoading, false);
    });

    test('사용자가 없으면 로딩만 해제되어야 한다', () async {
      // given
      when(mockUserUseCase.getCurrentUser())
          .thenAnswer((_) async => null);

      // when
      await viewModel.loadUserPreferences();

      // then
      expect(viewModel.state.isLoading, false);
    });
  });
}