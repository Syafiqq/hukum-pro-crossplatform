import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_menu_navigation_list_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_menu_navigation_list_state.dart';
import 'package:hukum_pro/common/exception/defined_exception.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'load_law_menu_cubit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<LawMenuOrderRepository>(
      as: #BaseMockLawMenuOrderRepository, returnNullOnMissingStub: true),
])
void main() {
  group('$LawMenuNavigationListCubit', () {
    late BaseMockLawMenuOrderRepository mockLawMenuOrderRepository;

    setUp(() {
      mockLawMenuOrderRepository = BaseMockLawMenuOrderRepository();
    });

    test('it produce initial state', () {
      var cubit = LawMenuNavigationListCubit(mockLawMenuOrderRepository);
      expect(
        cubit.state,
        isA<InitialState>(),
      );
    });

    group('load', () {
      blocTest<LawMenuNavigationListCubit, LawMenuNavigationListState>(
        'it should do nothing',
        build: () {
          var cubit = LawMenuNavigationListCubit(mockLawMenuOrderRepository);
          cubit.emit(LawMenuNavigationListState.loading());
          return cubit;
        },
        act: (cubit) => cubit.load(),
        expect: () => isEmpty,
      );

      blocTest<LawMenuNavigationListCubit, LawMenuNavigationListState>(
        'it should produce initial -> loading -> load success',
        build: () {
          when(mockLawMenuOrderRepository.fetchFromLocal())
              .thenAnswer((_) => Future.value([]));
          return LawMenuNavigationListCubit(mockLawMenuOrderRepository);
        },
        act: (cubit) => cubit.load(),
        expect: () => <Matcher>[
          isA<MenuLoading>(),
          isA<MenuLoadSuccess>(),
        ],
      );

      blocTest<LawMenuNavigationListCubit, LawMenuNavigationListState>(
        'it should produce initial -> loading -> load failed',
        build: () {
          when(mockLawMenuOrderRepository.fetchFromLocal()).thenAnswer(
              (_) => Future.error(DefinedException(null, null, null, null)));

          return LawMenuNavigationListCubit(mockLawMenuOrderRepository);
        },
        act: (cubit) => cubit.load(),
        expect: () => <Matcher>[isA<MenuLoading>(), isA<MenuLoadFailed>()],
      );
    });
  });
}
