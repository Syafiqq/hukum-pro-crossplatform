import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/entity/version/check_local_version_state.dart';
import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case_impl.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/common/exception/defined_exception.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'reinitialize_whole_data_use_case_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<LawRepository>(
      as: #BaseMockLawRepository, returnNullOnMissingStub: true),
  MockSpec<LawYearRepository>(
      as: #BaseMockLawYearRepository, returnNullOnMissingStub: true),
  MockSpec<BulkLawsRepository>(
      as: #BaseMockBulkLawsRepository, returnNullOnMissingStub: true),
])
void main() {
  group('$CheckVersionFirstTimeUseCase', () {
    late BaseMockLawRepository mockLawRepository;
    late BaseMockLawYearRepository mockLawYearRepository;
    late BaseMockBulkLawsRepository mockBulkLawsRepository;
    late ReinitializeWholeDataUseCase useCase;

    setUp(() {});

    test('it should return local version present', () async {});

    test('it should return remote version present', () async {});

    test('it should throw an error from local fetch', () async {});

    test('it should throw an error from remote fetch', () async {});
  });
}
