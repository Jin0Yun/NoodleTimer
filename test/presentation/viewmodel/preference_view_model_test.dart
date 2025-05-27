import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';
import 'package:noodle_timer/domain/entity/user_entity.dart';
import 'package:noodle_timer/domain/usecase/user_usecase.dart';
import 'package:noodle_timer/presentation/viewmodel/preference_view_model.dart';
import 'preference_view_model_test.mocks.dart';

@GenerateMocks([UserUseCase, AppLogger])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testUserId = 'test-user-id';
  final testUser = UserEntity(
    uid: testUserId,
    email: 'test@example.com',
    favoriteRamenIds: [],
    noodlePreference: NoodlePreference.kodul,
    eggPreference: EggPreference.none,
    createdAt: DateTime.now(),
  );

  group('PreferenceViewModel 설정 업데이트 테스트', () {
    late MockUserUseCase mockUserUseCase;
    late MockAppLogger mockLogger;
    late PreferenceViewModel viewModel;

    setUp(() {
      mockUserUseCase = MockUserUseCase();
      mockLogger = MockAppLogger();
      viewModel = PreferenceViewModel(mockUserUseCase, testUserId, mockLogger);
    });

    test('면 선호도 업데이트가 정상적으로 작동해야 한다', () {
      // when
      viewModel.updateNoodlePreference(NoodlePreference.peojin);

      // then
      expect(viewModel.state.noodlePreference, NoodlePreference.peojin);
    });
  });

  group('PreferenceViewModel 설정 저장 테스트', () {
    late MockUserUseCase mockUserUseCase;
    late MockAppLogger mockLogger;
    late PreferenceViewModel viewModel;

    setUp(() {
      mockUserUseCase = MockUserUseCase();
      mockLogger = MockAppLogger();
      viewModel = PreferenceViewModel(mockUserUseCase, testUserId, mockLogger);
    });

    test('설정 저장 성공 시 true가 반환되어야 한다', () async {
      // given
      viewModel.updateNoodlePreference(NoodlePreference.peojin);
      when(
        mockUserUseCase.updateNoodlePreference(
          testUserId,
          NoodlePreference.peojin,
        ),
      ).thenAnswer((_) async {});

      // when
      final result = await viewModel.savePreferences();

      // then
      expect(result, true);
      expect(viewModel.state.isLoading, false);
    });
  });

  group('PreferenceViewModel 사용자 설정 로드 테스트', () {
    late MockUserUseCase mockUserUseCase;
    late MockAppLogger mockLogger;
    late PreferenceViewModel viewModel;

    setUp(() {
      mockUserUseCase = MockUserUseCase();
      mockLogger = MockAppLogger();
      viewModel = PreferenceViewModel(mockUserUseCase, testUserId, mockLogger);
    });

    test('사용자 설정 로드 성공 시 상태가 업데이트되어야 한다', () async {
      // given
      when(mockUserUseCase.getCurrentUser()).thenAnswer((_) async => testUser);

      // when
      await viewModel.loadUserPreferences();

      // then
      expect(viewModel.state.noodlePreference, NoodlePreference.kodul);
      expect(viewModel.state.isLoading, false);
    });

    test('사용자가 없으면 로딩만 해제되어야 한다', () async {
      // given
      when(mockUserUseCase.getCurrentUser()).thenAnswer((_) async => null);

      // when
      await viewModel.loadUserPreferences();

      // then
      expect(viewModel.state.isLoading, false);
    });
  });
}