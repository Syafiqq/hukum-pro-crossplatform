import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case_impl.dart';
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

    setUp(() {
      mockBulkLawsRepository = BaseMockBulkLawsRepository();
      mockLawRepository = BaseMockLawRepository();
      mockLawYearRepository = BaseMockLawYearRepository();
      useCase = ReinitializeWholeDataUseCaseImpl(
          mockBulkLawsRepository, mockLawRepository, mockLawYearRepository);
    });

    test('should execute the use case', () async {
      when(mockBulkLawsRepository.getFileReference(any, any))
          .thenAnswer((_) => Future.value([File('1'), File('2')]));
      when(mockBulkLawsRepository.downloadLaw(any, any))
          .thenAnswer((_) => Future.value(null));
      when(mockBulkLawsRepository.decodeFile(
              argThat(isA<File>().having((e) => e.path, 'path', '1'))))
          .thenAnswer((_) => Future.value(
              [LawEntity(1, '1', 1, null, null, null, null, null, null)]));
      when(mockBulkLawsRepository.decodeFile(
              argThat(isA<File>().having((e) => e.path, 'path', '2'))))
          .thenAnswer((_) => Future.value(
              [LawEntity(2, '2', 2, null, null, null, null, null, null)]));
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawRepository.addAll(any)).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll())
          .thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.addAll(any))
          .thenAnswer((_) => Future.value(null));

      await useCase
          .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3'));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);

      expect(
          verify(mockBulkLawsRepository.getFileReference(
                  captureAny, captureAny))
              .captured,
          [
            '2', // id
            ['1', '2'] // filenames
          ]);

      expect(
          verify(mockBulkLawsRepository.downloadLaw(captureAny, captureAny))
              .captured,
          [
            '1',
            isA<File>().having((e) => e.path, 'path', '1'),
            '2',
            isA<File>().having((e) => e.path, 'path', '2')
          ]);

      expect(verify(mockBulkLawsRepository.decodeFile(captureAny)).captured, [
        isA<File>().having((e) => e.path, 'path', '1'),
        isA<File>().having((e) => e.path, 'path', '2')
      ]);

      expect(verify(mockLawRepository.addAll(captureAny)).captured, [
        [
          isA<LawEntity>()
              .having((e) => e.id, 'id', 1)
              .having((e) => e.remoteId, 'remoteId', '1')
              .having((e) => e.year, 'year', 1)
        ],
        [
          isA<LawEntity>()
              .having((e) => e.id, 'id', 2)
              .having((e) => e.remoteId, 'remoteId', '2')
              .having((e) => e.year, 'year', 2)
        ]
      ]);

      expect(verify(mockLawYearRepository.addAll(captureAny)).captured, [
        [
          isA<LawYearEntity>()
              .having((e) => e.id, 'id', 1)
              .having((e) => e.year, 'year', 1)
              .having((e) => e.count, 'count', 1),
          isA<LawYearEntity>()
              .having((e) => e.id, 'id', 2)
              .having((e) => e.year, 'year', 2)
              .having((e) => e.count, 'count', 1)
        ],
      ]);
    });
  });
}
