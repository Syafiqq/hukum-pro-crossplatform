import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/service/active_law_service.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_per_year_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_per_year_load_state.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_year_load_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'load_law_per_year_cubit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<LawRepository>(
      as: #BaseMockLawRepository, returnNullOnMissingStub: true),
  MockSpec<ActiveLawService>(
      as: #BaseMockActiveLawService, returnNullOnMissingStub: true),
])
void main() {
  group('$LoadLawMenuCubit', () {
    late BaseMockLawRepository mockLawRepository;
    late BaseMockActiveLawService mockActiveLawService;

    setUp(() {
      mockLawRepository = BaseMockLawRepository();
      mockActiveLawService = BaseMockActiveLawService();
    });

    group('initial', () {
      test('it produce initial state', () {
        var cubit =
            LoadLawPerYearCubit(mockLawRepository, mockActiveLawService);
        expect(
          cubit.state,
          isA<LawPerYearLoadState>()
              .having(
                (state) => state.state,
                'state',
                LawYearLoadUiState.initial,
              )
              .having(
                (state) => state.laws,
                'laws',
                isEmpty,
              ),
        );
      });
    });

    group('resetAndLoad', () {
      Future<void> testSuccessFlow({
        required LawPerYearLoadState initial,
        dynamic Function()? expectOverride,
      }) async {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            when(mockActiveLawService.getActiveYear()).thenReturn(1);
            when(mockActiveLawService.getActiveLawId()).thenReturn('1');

            var cubit =
                LoadLawPerYearCubit(mockLawRepository, mockActiveLawService);
            cubit.emit(initial);
            return cubit;
          },
          act: (cubit) => cubit.resetAndLoad(),
          expect: expectOverride ??
              () => <Matcher>[
                    isA<LawPerYearLoadState>().having(
                      (state) => state.state,
                      'state',
                      LawYearLoadUiState.reset,
                    ),
                    isA<LawPerYearLoadState>().having(
                      (state) => state.state,
                      'state',
                      LawYearLoadUiState.loading,
                    ),
                    isA<LawPerYearLoadState>().having(
                      (state) => state.state,
                      'state',
                      LawYearLoadUiState.loadSuccess,
                    ),
                  ],
        );
      }

      Future<void> testEmptyFlow({required LawPerYearLoadState initial}) async {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            when(mockActiveLawService.getActiveYear()).thenReturn(1);
            when(mockActiveLawService.getActiveLawId()).thenReturn('1');
            var cubit =
                LoadLawPerYearCubit(mockLawRepository, mockActiveLawService);
            cubit.emit(initial);
            return cubit;
          },
          act: (cubit) => cubit.resetAndLoad(),
          expect: () => <Matcher>[],
        );
      }

      test('it should produce (reset -> loading -> load success) from initial',
          () {
        testSuccessFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.initial,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test(
          'it should produce (reset -> loading -> load success) from loadSuccess',
          () {
        testSuccessFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.loadSuccess,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test(
          'it should produce (reset -> loading -> load success) from loadFailed',
          () {
        testSuccessFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.loadFailed,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should produce (loading -> load success) from reset', () {
        testSuccessFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.reset,
            laws: [],
            hasMore: true,
          ),
          expectOverride: () => <Matcher>[
            isA<LawPerYearLoadState>().having(
              (state) => state.state,
              'state',
              LawYearLoadUiState.loading,
            ),
            isA<LawPerYearLoadState>().having(
              (state) => state.state,
              'state',
              LawYearLoadUiState.loadSuccess,
            ),
          ],
        );
      });

      test('it should do nothing from loading', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.loading,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should do nothing from loadMore', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.loadMore,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should do nothing if no year present', () {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            var cubit =
                LoadLawPerYearCubit(mockLawRepository, mockActiveLawService);
            return cubit;
          },
          act: (cubit) => cubit.resetAndLoad(),
          expect: () => <Matcher>[],
        );
      });

      test('it should do nothing if no law id present', () {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            var cubit =
                LoadLawPerYearCubit(mockLawRepository, mockActiveLawService);
            return cubit;
          },
          act: (cubit) => cubit.resetAndLoad(),
          expect: () => <Matcher>[],
        );
      });

      test('it should do nothing if no law id and year present', () {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            var cubit =
                LoadLawPerYearCubit(mockLawRepository, mockActiveLawService);
            return cubit;
          },
          act: (cubit) => cubit.resetAndLoad(),
          expect: () => <Matcher>[],
        );
      });
    });

    group('loadMore', () {
      Future<void> testSuccessFlow({
        required LawPerYearLoadState initial,
        dynamic Function()? expectOverride,
      }) async {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            when(mockActiveLawService.getActiveYear()).thenReturn(1);
            when(mockActiveLawService.getActiveLawId()).thenReturn('1');

            var cubit =
                LoadLawPerYearCubit(mockLawRepository, mockActiveLawService);
            cubit.emit(initial);
            return cubit;
          },
          act: (cubit) => cubit.loadMore(),
          expect: expectOverride ??
              () => <Matcher>[
                    isA<LawPerYearLoadState>().having(
                      (state) => state.state,
                      'state',
                      LawYearLoadUiState.loadMore,
                    ),
                    isA<LawPerYearLoadState>().having(
                      (state) => state.state,
                      'state',
                      LawYearLoadUiState.loadSuccess,
                    ),
                  ],
        );
      }

      Future<void> testEmptyFlow({required LawPerYearLoadState initial}) async {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            when(mockActiveLawService.getActiveYear()).thenReturn(1);
            when(mockActiveLawService.getActiveLawId()).thenReturn('1');
            var cubit =
                LoadLawPerYearCubit(mockLawRepository, mockActiveLawService);
            cubit.emit(initial);
            return cubit;
          },
          act: (cubit) => cubit.loadMore(),
          expect: () => <Matcher>[],
        );
      }

      test('it should produce empty from initial', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.initial,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should produce (loading -> load success) from loadSuccess', () {
        testSuccessFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.loadSuccess,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should produce (loading -> load success) from loadFailed', () {
        testSuccessFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.loadFailed,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should produce (loading -> load success) from reset', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.reset,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should do nothing from loading', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.loading,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should do nothing from loadMore', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.loadMore,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should do nothing from if no more incoming data', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LawYearLoadUiState.loadSuccess,
            laws: [],
            hasMore: false,
          ),
        );
      });

      test('it should do nothing if no year present', () {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            var cubit =
                LoadLawPerYearCubit(mockLawRepository, mockActiveLawService);
            return cubit;
          },
          act: (cubit) => cubit.loadMore(),
          expect: () => <Matcher>[],
        );
      });

      test('it should do nothing if no law id present', () {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            var cubit =
                LoadLawPerYearCubit(mockLawRepository, mockActiveLawService);
            return cubit;
          },
          act: (cubit) => cubit.loadMore(),
          expect: () => <Matcher>[],
        );
      });

      test('it should do nothing if no law id and year present', () {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            var cubit =
                LoadLawPerYearCubit(mockLawRepository, mockActiveLawService);
            return cubit;
          },
          act: (cubit) => cubit.loadMore(),
          expect: () => <Matcher>[],
        );
      });
    });
  });
}
