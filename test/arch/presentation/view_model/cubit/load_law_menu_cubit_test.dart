import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_menu_navigation_state.dart';
import 'package:hukum_pro/common/exception/defined_exception.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'load_law_menu_cubit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<LawMenuOrderRepository>(
      as: #BaseMockLawMenuOrderRepository, returnNullOnMissingStub: true),
])
void main() {
  group('$LoadLawMenuCubit', () {
    late BaseMockLawMenuOrderRepository mockLawMenuOrderRepository;

    setUp(() {
      mockLawMenuOrderRepository = BaseMockLawMenuOrderRepository();
    });

    test('it produce initial state', () {
      var cubit = LoadLawMenuCubit(mockLawMenuOrderRepository);
      expect(
        cubit.state,
        isA<InitialState>(),
      );
    });

    group('load', () {
      blocTest<LoadLawMenuCubit, LawMenuNavigationUiState>(
        'it should do nothing',
        build: () {
          var cubit = LoadLawMenuCubit(mockLawMenuOrderRepository);
          cubit.emit(LawMenuNavigationUiState.loading());
          return cubit;
        },
        act: (cubit) => cubit.load(),
        expect: () => isEmpty,
      );

      blocTest<LoadLawMenuCubit, LawMenuNavigationUiState>(
        'it should produce initial -> loading -> load success',
        build: () {
          when(mockLawMenuOrderRepository.fetchFromLocal())
              .thenAnswer((_) => Future.value([]));
          return LoadLawMenuCubit(mockLawMenuOrderRepository);
        },
        act: (cubit) => cubit.load(),
        expect: () => <Matcher>[
          isA<MenuLoading>(),
          isA<MenuLoadSuccess>(),
        ],
      );

      blocTest<LoadLawMenuCubit, LawMenuNavigationUiState>(
        'it should produce initial -> loading -> load failed',
        build: () {
          when(mockLawMenuOrderRepository.fetchFromLocal()).thenAnswer(
              (_) => Future.error(DefinedException(null, null, null, null)));

          return LoadLawMenuCubit(mockLawMenuOrderRepository);
        },
        act: (cubit) => cubit.load(),
        expect: () => <Matcher>[isA<MenuLoading>(), isA<MenuLoadFailed>()],
      );
    });
  });
}
