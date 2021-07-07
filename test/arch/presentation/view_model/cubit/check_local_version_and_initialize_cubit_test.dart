import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/entity/version/check_local_version_state.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_and_initialize_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/check_local_version_and_initialize_state.dart';
import 'package:hukum_pro/common/exception/defined_exception.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'check_local_version_and_initialize_cubit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<CheckVersionFirstTimeUseCase>(
      as: #BaseMockCheckVersionFirstTimeUseCase, returnNullOnMissingStub: true),
  MockSpec<ReinitializeWholeDataUseCase>(
      as: #BaseMockReinitializeWholeDataUseCase, returnNullOnMissingStub: true),
])
void main() {
  group('$CheckLocalVersionAndInitializeCubit', () {
    late BaseMockCheckVersionFirstTimeUseCase mockCheckVersionFirstTimeUseCase;
    late BaseMockReinitializeWholeDataUseCase mockReinitializeWholeDataUseCase;

    setUp(() {
      mockCheckVersionFirstTimeUseCase = BaseMockCheckVersionFirstTimeUseCase();
      mockReinitializeWholeDataUseCase = BaseMockReinitializeWholeDataUseCase();
    });

    test('it produce initial state', () {
      var cubit = CheckLocalVersionAndInitializeCubit(
        mockCheckVersionFirstTimeUseCase,
        mockReinitializeWholeDataUseCase,
      );
      expect(
        cubit.state,
        isA<InitialState>(),
      );
    });

    group('checkVersion', () {
      blocTest<CheckLocalVersionAndInitializeCubit,
          CheckLocalVersionAndInitializeUiState>(
        'it should do nothing',
        build: () {
          var cubit = CheckLocalVersionAndInitializeCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
          );
          cubit.emit(CheckLocalVersionAndInitializeUiState.versionLoading());
          return cubit;
        },
        act: (cubit) => cubit.checkVersion(),
        expect: () => isEmpty,
      );

      blocTest<CheckLocalVersionAndInitializeCubit,
          CheckLocalVersionAndInitializeUiState>(
        'it should produce initial -> loading -> version present',
        build: () {
          when(mockCheckVersionFirstTimeUseCase.execute()).thenAnswer((_) =>
              Future.value(CheckLocalVersionState.localPresent(
                  VersionEntity(null, null, null))));
          return CheckLocalVersionAndInitializeCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
          );
        },
        act: (cubit) => cubit.checkVersion(),
        expect: () => <Matcher>[
          isA<VersionLoading>(),
          isA<VersionLocalPresent>().having(
              (e) => e.version,
              'version',
              isA<VersionEntity>()
                  .having((e) => e.detail, 'detail', null)
                  .having((e) => e.milis, 'milis', null)
                  .having((e) => e.timestamp, 'timestamp', null)),
        ],
      );

      blocTest<CheckLocalVersionAndInitializeCubit,
          CheckLocalVersionAndInitializeUiState>(
        'it should produce initial -> loading -> not present',
        build: () {
          when(mockCheckVersionFirstTimeUseCase.execute()).thenAnswer((_) =>
              Future.value(CheckLocalVersionState.needInitializeVersion(
                  VersionEntity(null, null, null))));
          when(mockReinitializeWholeDataUseCase.execute(any))
              .thenAnswer((_) => Future.value(null));
          return CheckLocalVersionAndInitializeCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
          );
        },
        act: (cubit) => cubit.checkVersion(),
        expect: () => <Matcher>[
          isA<VersionLoading>(),
          isA<VersionLocalNotPresent>().having(
              (e) => e.version,
              'version',
              isA<VersionEntity>()
                  .having((e) => e.detail, 'detail', null)
                  .having((e) => e.milis, 'milis', null)
                  .having((e) => e.timestamp, 'timestamp', null)),
          isA<InitializeLoading>(),
          isA<InitializeSuccess>(),
        ],
      );

      blocTest<CheckLocalVersionAndInitializeCubit,
          CheckLocalVersionAndInitializeUiState>(
        'it should produce initial -> loading -> not present',
        build: () {
          when(mockCheckVersionFirstTimeUseCase.execute()).thenAnswer((_) =>
              Future.value(CheckLocalVersionState.needInitializeVersion(
                  VersionEntity(null, null, null))));

          return CheckLocalVersionAndInitializeCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
          );
        },
        act: (cubit) => cubit.checkVersion(),
        expect: () => <Matcher>[
          isA<VersionLoading>(),
          isA<VersionLocalNotPresent>().having(
              (e) => e.version,
              'version',
              isA<VersionEntity>()
                  .having((e) => e.detail, 'detail', null)
                  .having((e) => e.milis, 'milis', null)
                  .having((e) => e.timestamp, 'timestamp', null)),
          isA<InitializeLoading>(),
          isA<InitializeSuccess>(),
        ],
      );

      blocTest<CheckLocalVersionAndInitializeCubit,
          CheckLocalVersionAndInitializeUiState>(
        'it should produce initial -> loading -> failure',
        build: () {
          when(mockCheckVersionFirstTimeUseCase.execute()).thenAnswer(
              (_) => Future.error(DefinedException(null, null, null, null)));
          return CheckLocalVersionAndInitializeCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
          );
        },
        act: (cubit) => cubit.checkVersion(),
        expect: () => <Matcher>[
          isA<VersionLoading>(),
          isA<VersionCheckFailed>(),
        ],
      );
    });

    group('reinitializeApp', () {
      blocTest<CheckLocalVersionAndInitializeCubit,
          CheckLocalVersionAndInitializeUiState>(
        'it should do nothing at initial state',
        build: () {
          return CheckLocalVersionAndInitializeCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
          );
        },
        act: (cubit) => cubit.initializeApp(VersionEntity(null, null, null)),
        expect: () => isEmpty,
      );

      blocTest<CheckLocalVersionAndInitializeCubit,
          CheckLocalVersionAndInitializeUiState>(
        'it should do nothing when check version',
        build: () {
          var cubit = CheckLocalVersionAndInitializeCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
          );
          cubit.emit(CheckLocalVersionAndInitializeUiState.versionLoading());
          return cubit;
        },
        act: (cubit) => cubit.initializeApp(VersionEntity(null, null, null)),
        expect: () => isEmpty,
      );

      blocTest<CheckLocalVersionAndInitializeCubit,
          CheckLocalVersionAndInitializeUiState>(
        'it should do nothing initialize has been being processed',
        build: () {
          var cubit = CheckLocalVersionAndInitializeCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
          );
          cubit.emit(
              CheckLocalVersionAndInitializeUiState.initializeAppLoading());
          return cubit;
        },
        act: (cubit) => cubit.initializeApp(VersionEntity(null, null, null)),
        expect: () => isEmpty,
      );

      blocTest<CheckLocalVersionAndInitializeCubit,
          CheckLocalVersionAndInitializeUiState>(
        'it should produce loading initialize -> success',
        build: () {
          when(mockReinitializeWholeDataUseCase.execute(any))
              .thenAnswer((_) => Future.value(null));
          var cubit = CheckLocalVersionAndInitializeCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
          );
          cubit.emit(
              CheckLocalVersionAndInitializeUiState.versionNotExistButRemote(
                  VersionEntity(null, null, null)));
          return cubit;
        },
        act: (cubit) => cubit.initializeApp(VersionEntity(null, null, null)),
        expect: () => <Matcher>[
          isA<InitializeLoading>(),
          isA<InitializeSuccess>(),
        ],
      );

      blocTest<CheckLocalVersionAndInitializeCubit,
          CheckLocalVersionAndInitializeUiState>(
        'it should produce loading initialize -> failed',
        build: () {
          when(mockReinitializeWholeDataUseCase.execute(any)).thenAnswer(
              (_) => Future.error(DefinedException(null, null, null, null)));
          var cubit = CheckLocalVersionAndInitializeCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
          );
          cubit.emit(
              CheckLocalVersionAndInitializeUiState.versionNotExistButRemote(
                  VersionEntity(null, null, null)));
          return cubit;
        },
        act: (cubit) => cubit.initializeApp(VersionEntity(null, null, null)),
        expect: () => <Matcher>[
          isA<InitializeLoading>(),
          isA<InitializeFailed>(),
        ],
      );
    });
  });
}
