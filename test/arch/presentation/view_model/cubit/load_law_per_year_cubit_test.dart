import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/presentation/state/load_more_data_fetcher_state.dart';
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
  MockSpec<LawMenuOrderRepository>(
      as: #BaseMockLawMenuOrderRepository, returnNullOnMissingStub: true),
])
void main() {
  group('$LoadLawMenuCubit', () {
    late BaseMockLawRepository mockLawRepository;
    late BaseMockLawMenuOrderRepository mockLawMenuOrderRepository;

    setUp(() {
      mockLawRepository = BaseMockLawRepository();
      mockLawMenuOrderRepository = BaseMockLawMenuOrderRepository();
    });

    group('initial', () {
      test('it produce initial state', () {
        var cubit =
            LoadLawPerYearCubit(mockLawRepository, mockLawMenuOrderRepository);
        expect(
          cubit.state,
          isA<LawPerYearLoadState>()
              .having(
                (state) => state.state,
                'state',
                LoadMoreDataFetcherState.initial,
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
            when(mockLawMenuOrderRepository.fetchFromLocal()).thenAnswer(
                (_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));

            var cubit = LoadLawPerYearCubit(
                mockLawRepository, mockLawMenuOrderRepository);
            cubit.emit(initial);
            return cubit;
          },
          act: (cubit) => cubit.resetAndLoad(menuId: '1', year: 1),
          expect: expectOverride ??
              () => <Matcher>[
                    isA<LawPerYearLoadState>().having(
                      (state) => state.state,
                      'state',
                      LoadMoreDataFetcherState.reset,
                    ),
                    isA<LawPerYearLoadState>().having(
                      (state) => state.state,
                      'state',
                      LoadMoreDataFetcherState.loading,
                    ),
                    isA<LawPerYearLoadState>().having(
                      (state) => state.state,
                      'state',
                      LoadMoreDataFetcherState.loadSuccess,
                    ),
                  ],
        );
      }

      Future<void> testEmptyFlow({required LawPerYearLoadState initial}) async {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            when(mockLawMenuOrderRepository.fetchFromLocal()).thenAnswer(
                (_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));
            var cubit = LoadLawPerYearCubit(
                mockLawRepository, mockLawMenuOrderRepository);
            cubit.emit(initial);
            return cubit;
          },
          act: (cubit) => cubit.resetAndLoad(menuId: '1', year: 1),
          expect: () => <Matcher>[],
        );
      }

      test('it should produce (reset -> loading -> load success) from initial',
          () {
        testSuccessFlow(
          initial: LawPerYearLoadState(
            state: LoadMoreDataFetcherState.initial,
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
            state: LoadMoreDataFetcherState.loadSuccess,
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
            state: LoadMoreDataFetcherState.loadFailed,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should produce (loading -> load success) from reset', () {
        testSuccessFlow(
          initial: LawPerYearLoadState(
            state: LoadMoreDataFetcherState.reset,
            laws: [],
            hasMore: true,
          ),
          expectOverride: () => <Matcher>[
            isA<LawPerYearLoadState>().having(
              (state) => state.state,
              'state',
              LoadMoreDataFetcherState.loading,
            ),
            isA<LawPerYearLoadState>().having(
              (state) => state.state,
              'state',
              LoadMoreDataFetcherState.loadSuccess,
            ),
          ],
        );
      });

      test('it should do nothing from loading', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LoadMoreDataFetcherState.loading,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should do nothing from loadMore', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LoadMoreDataFetcherState.loadMore,
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
            var cubit = LoadLawPerYearCubit(
                mockLawRepository, mockLawMenuOrderRepository);
            return cubit;
          },
          act: (cubit) => cubit.resetAndLoad(menuId: '1', year: 1),
          expect: () => <Matcher>[],
        );
      });

      test('it should do nothing if no law id present', () {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            var cubit = LoadLawPerYearCubit(
                mockLawRepository, mockLawMenuOrderRepository);
            return cubit;
          },
          act: (cubit) => cubit.resetAndLoad(menuId: '1', year: 1),
          expect: () => <Matcher>[],
        );
      });

      test('it should do nothing if no law id and year present', () {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            var cubit = LoadLawPerYearCubit(
                mockLawRepository, mockLawMenuOrderRepository);
            return cubit;
          },
          act: (cubit) => cubit.resetAndLoad(menuId: '1', year: 1),
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
            when(mockLawMenuOrderRepository.fetchFromLocal()).thenAnswer(
                (_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));

            var cubit = LoadLawPerYearCubit(
                mockLawRepository, mockLawMenuOrderRepository);
            cubit.emit(initial);
            return cubit;
          },
          act: (cubit) => cubit.loadMore(),
          expect: expectOverride ??
              () => <Matcher>[
                    isA<LawPerYearLoadState>().having(
                      (state) => state.state,
                      'state',
                      LoadMoreDataFetcherState.loadMore,
                    ),
                    isA<LawPerYearLoadState>().having(
                      (state) => state.state,
                      'state',
                      LoadMoreDataFetcherState.loadSuccess,
                    ),
                  ],
        );
      }

      Future<void> testEmptyFlow({required LawPerYearLoadState initial}) async {
        testBloc<LoadLawPerYearCubit, LawPerYearLoadState>(
          build: () {
            when(mockLawRepository.getByYear(any, any, any, any))
                .thenAnswer((_) => Future.value([]));
            when(mockLawMenuOrderRepository.fetchFromLocal()).thenAnswer(
                (_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));
            var cubit = LoadLawPerYearCubit(
                mockLawRepository, mockLawMenuOrderRepository);
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
            state: LoadMoreDataFetcherState.initial,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should produce (loading -> load success) from loadSuccess', () {
        testSuccessFlow(
          initial: LawPerYearLoadState(
            state: LoadMoreDataFetcherState.loadSuccess,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should produce (loading -> load success) from loadFailed', () {
        testSuccessFlow(
          initial: LawPerYearLoadState(
            state: LoadMoreDataFetcherState.loadFailed,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should produce (loading -> load success) from reset', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LoadMoreDataFetcherState.reset,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should do nothing from loading', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LoadMoreDataFetcherState.loading,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should do nothing from loadMore', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LoadMoreDataFetcherState.loadMore,
            laws: [],
            hasMore: true,
          ),
        );
      });

      test('it should do nothing from if no more incoming data', () {
        testEmptyFlow(
          initial: LawPerYearLoadState(
            state: LoadMoreDataFetcherState.loadSuccess,
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
            var cubit = LoadLawPerYearCubit(
                mockLawRepository, mockLawMenuOrderRepository);
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
            var cubit = LoadLawPerYearCubit(
                mockLawRepository, mockLawMenuOrderRepository);
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
            var cubit = LoadLawPerYearCubit(
                mockLawRepository, mockLawMenuOrderRepository);
            return cubit;
          },
          act: (cubit) => cubit.loadMore(),
          expect: () => <Matcher>[],
        );
      });
    });
  });
}
