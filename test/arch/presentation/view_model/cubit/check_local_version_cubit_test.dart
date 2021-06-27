import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/entity/version/check_local_version_state.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/check_local_version_ui_state.dart';
import 'package:hukum_pro/common/exception/defined_exception.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'check_local_version_cubit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<CheckVersionFirstTimeUseCase>(
      as: #BaseMockCheckVersionFirstTimeUseCase, returnNullOnMissingStub: true),
])
void main() {
  group('$CheckLocalVersionCubit', () {
    late BaseMockCheckVersionFirstTimeUseCase mockCheckVersionFirstTimeUseCase;
    late CheckLocalVersionCubit cubit;

    setUp(() {
      mockCheckVersionFirstTimeUseCase = BaseMockCheckVersionFirstTimeUseCase();
      cubit = CheckLocalVersionCubit(mockCheckVersionFirstTimeUseCase);
    });

    test('it produce initial state', () {
      expect(
          cubit.state,
          isA<CheckLocalVersionUiState>()
              .having(
                  (e) => e.status, 'status', CheckLocalVersionUiStatus.initial)
              .having((e) => e.state, 'state', isNull));
    });

    group('checkVersion', () {
      blocTest<CheckLocalVersionCubit, CheckLocalVersionUiState>(
        'it should do nothing',
        build: () {
          var cubit = CheckLocalVersionCubit(mockCheckVersionFirstTimeUseCase);
          cubit.emit(
              cubit.state.copyWith(status: CheckLocalVersionUiStatus.loading));
          return cubit;
        },
        act: (cubit) => cubit.checkVersion(),
        expect: () => isEmpty,
      );

      blocTest<CheckLocalVersionCubit, CheckLocalVersionUiState>(
        'it should produce initial -> loading',
        build: () {
          when(mockCheckVersionFirstTimeUseCase.execute()).thenAnswer((_) =>
              Future.value(CheckLocalVersionState.localPresent(
                  VersionEntity(null, null, null))));
          return CheckLocalVersionCubit(mockCheckVersionFirstTimeUseCase);
        },
        act: (cubit) => cubit.checkVersion(),
        expect: () => <Matcher>[
          isA<CheckLocalVersionUiState>()
              .having(
                  (e) => e.status, 'status', CheckLocalVersionUiStatus.loading)
              .having((e) => e.state, 'state', isNull),
          isA<CheckLocalVersionUiState>()
        ],
      );

      blocTest<CheckLocalVersionCubit, CheckLocalVersionUiState>(
        'it should produce initial -> loading -> success',
        build: () {
          when(mockCheckVersionFirstTimeUseCase.execute()).thenAnswer((_) =>
              Future.value(CheckLocalVersionState.localPresent(
                  VersionEntity(null, null, null))));
          return CheckLocalVersionCubit(mockCheckVersionFirstTimeUseCase);
        },
        act: (cubit) => cubit.checkVersion(),
        expect: () => <Matcher>[
          isA<CheckLocalVersionUiState>()
              .having(
                  (e) => e.status, 'status', CheckLocalVersionUiStatus.loading)
              .having((e) => e.state, 'state', isNull),
          isA<CheckLocalVersionUiState>()
              .having(
                  (e) => e.status, 'status', CheckLocalVersionUiStatus.success)
              .having(
                  (e) => e.state,
                  'state',
                  isA<LocalVersionPresent>().having(
                      (e) => e.version,
                      'version',
                      isA<VersionEntity>()
                          .having((e) => e.detail, 'detail', null)
                          .having((e) => e.milis, 'milis', null)
                          .having((e) => e.timestamp, 'timestamp', null))),
        ],
      );

      blocTest<CheckLocalVersionCubit, CheckLocalVersionUiState>(
        'it should produce initial -> loading -> failure',
        build: () {
          when(mockCheckVersionFirstTimeUseCase.execute()).thenAnswer(
              (_) => Future.error(DefinedException(null, null, null, null)));
          return CheckLocalVersionCubit(mockCheckVersionFirstTimeUseCase);
        },
        act: (cubit) => cubit.checkVersion(),
        expect: () => <Matcher>[
          isA<CheckLocalVersionUiState>()
              .having(
                  (e) => e.status, 'status', CheckLocalVersionUiStatus.loading)
              .having((e) => e.state, 'state', isNull),
          isA<CheckLocalVersionUiState>()
              .having(
                  (e) => e.status, 'status', CheckLocalVersionUiStatus.failure)
              .having((e) => e.state, 'state', isNull),
        ],
      );
    });
  });
}
