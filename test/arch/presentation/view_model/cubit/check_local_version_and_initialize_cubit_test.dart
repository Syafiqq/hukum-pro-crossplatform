import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/entity/version/check_local_version_state.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/initialize_app_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/initialize_app_state.dart';
import 'package:hukum_pro/common/exception/defined_exception.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'check_local_version_and_initialize_cubit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<CheckVersionFirstTimeUseCase>(
      as: #BaseMockCheckVersionFirstTimeUseCase, returnNullOnMissingStub: true),
  MockSpec<ReinitializeWholeDataUseCase>(
      as: #BaseMockReinitializeWholeDataUseCase, returnNullOnMissingStub: true),
  MockSpec<VersionRepository>(
      as: #BaseMockVersionRepository, returnNullOnMissingStub: true),
])
void main() {
  group('$InitializeAppCubit', () {
    late BaseMockCheckVersionFirstTimeUseCase mockCheckVersionFirstTimeUseCase;
    late BaseMockReinitializeWholeDataUseCase mockReinitializeWholeDataUseCase;
    late BaseMockVersionRepository mockVersionRepository;

    setUp(() {
      mockCheckVersionFirstTimeUseCase = BaseMockCheckVersionFirstTimeUseCase();
      mockReinitializeWholeDataUseCase = BaseMockReinitializeWholeDataUseCase();
      mockVersionRepository = BaseMockVersionRepository();
    });

    test('it produce initial state', () {
      var cubit = InitializeAppCubit(
        mockCheckVersionFirstTimeUseCase,
        mockReinitializeWholeDataUseCase,
        mockVersionRepository,
      );
      expect(
        cubit.state,
        isA<InitialState>(),
      );
    });

    group('checkVersion', () {
      blocTest<InitializeAppCubit,
          InitializeAppState>(
        'it should do nothing',
        build: () {
          var cubit = InitializeAppCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
            mockVersionRepository,
          );
          cubit.emit(InitializeAppState.versionLoading());
          return cubit;
        },
        act: (cubit) => cubit.checkVersion(),
        expect: () => isEmpty,
      );

      blocTest<InitializeAppCubit,
          InitializeAppState>(
        'it should produce initial -> loading -> version present',
        build: () {
          when(mockCheckVersionFirstTimeUseCase.execute()).thenAnswer((_) =>
              Future.value(CheckLocalVersionState.localPresent(
                  VersionEntity(null, null, null))));
          return InitializeAppCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
            mockVersionRepository,
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

      blocTest<InitializeAppCubit,
          InitializeAppState>(
        'it should produce initial -> loading -> not present',
        build: () {
          when(mockCheckVersionFirstTimeUseCase.execute()).thenAnswer((_) =>
              Future.value(CheckLocalVersionState.needInitializeVersion(
                  VersionEntity(null, null, null))));
          when(mockReinitializeWholeDataUseCase.execute(any))
              .thenAnswer((_) => Future.value(null));
          return InitializeAppCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
            mockVersionRepository,
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

      blocTest<InitializeAppCubit,
          InitializeAppState>(
        'it should produce initial -> loading -> not present',
        build: () {
          when(mockCheckVersionFirstTimeUseCase.execute()).thenAnswer((_) =>
              Future.value(CheckLocalVersionState.needInitializeVersion(
                  VersionEntity(null, null, null))));

          return InitializeAppCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
            mockVersionRepository,
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

      blocTest<InitializeAppCubit,
          InitializeAppState>(
        'it should produce initial -> loading -> failure',
        build: () {
          when(mockCheckVersionFirstTimeUseCase.execute()).thenAnswer(
              (_) => Future.error(DefinedException(null, null, null, null)));
          return InitializeAppCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
            mockVersionRepository,
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
      blocTest<InitializeAppCubit,
          InitializeAppState>(
        'it should do nothing at initial state',
        build: () {
          return InitializeAppCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
            mockVersionRepository,
          );
        },
        act: (cubit) => cubit.initializeApp(VersionEntity(null, null, null)),
        expect: () => isEmpty,
      );

      blocTest<InitializeAppCubit,
          InitializeAppState>(
        'it should do nothing when check version',
        build: () {
          var cubit = InitializeAppCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
            mockVersionRepository,
          );
          cubit.emit(InitializeAppState.versionLoading());
          return cubit;
        },
        act: (cubit) => cubit.initializeApp(VersionEntity(null, null, null)),
        expect: () => isEmpty,
      );

      blocTest<InitializeAppCubit,
          InitializeAppState>(
        'it should do nothing initialize has been being processed',
        build: () {
          var cubit = InitializeAppCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
            mockVersionRepository,
          );
          cubit.emit(
              InitializeAppState.initializeAppLoading());
          return cubit;
        },
        act: (cubit) => cubit.initializeApp(VersionEntity(null, null, null)),
        expect: () => isEmpty,
      );

      blocTest<InitializeAppCubit,
          InitializeAppState>(
        'it should produce loading initialize -> success',
        build: () {
          when(mockReinitializeWholeDataUseCase.execute(any))
              .thenAnswer((_) => Future.value(null));
          var cubit = InitializeAppCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
            mockVersionRepository,
          );
          cubit.emit(
              InitializeAppState.versionNotExistButRemote(
                  VersionEntity(null, null, null)));
          return cubit;
        },
        act: (cubit) => cubit.initializeApp(VersionEntity(null, null, null)),
        expect: () => <Matcher>[
          isA<InitializeLoading>(),
          isA<InitializeSuccess>(),
        ],
      );

      blocTest<InitializeAppCubit,
          InitializeAppState>(
        'it should produce loading initialize -> failed',
        build: () {
          when(mockReinitializeWholeDataUseCase.execute(any)).thenAnswer(
              (_) => Future.error(DefinedException(null, null, null, null)));
          var cubit = InitializeAppCubit(
            mockCheckVersionFirstTimeUseCase,
            mockReinitializeWholeDataUseCase,
            mockVersionRepository,
          );
          cubit.emit(
              InitializeAppState.versionNotExistButRemote(
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
