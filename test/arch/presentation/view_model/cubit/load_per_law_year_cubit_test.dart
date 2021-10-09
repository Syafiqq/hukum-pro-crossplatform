import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/service/active_law_service.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_per_law_year_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_per_year_load_state.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_year_load_state.dart';
import 'package:mockito/annotations.dart';

import 'load_per_law_year_cubit_test.mocks.dart';

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
  });
}
