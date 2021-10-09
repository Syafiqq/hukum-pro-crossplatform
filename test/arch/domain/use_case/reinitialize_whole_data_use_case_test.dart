import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case_impl.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
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
  MockSpec<LawMenuOrderRepository>(
      as: #BaseMockLawMenuOrderRepository, returnNullOnMissingStub: true),
])
void main() {
  group('$ReinitializeWholeDataUseCase', () {
    late BaseMockLawRepository mockLawRepository;
    late BaseMockLawYearRepository mockLawYearRepository;
    late BaseMockBulkLawsRepository mockBulkLawsRepository;
    late BaseMockLawMenuOrderRepository mockLawMenuOrderRepository;
    late ReinitializeWholeDataUseCase useCase;

    setUp(() {
      mockBulkLawsRepository = BaseMockBulkLawsRepository();
      mockLawRepository = BaseMockLawRepository();
      mockLawYearRepository = BaseMockLawYearRepository();
      mockLawMenuOrderRepository = BaseMockLawMenuOrderRepository();
      useCase = ReinitializeWholeDataUseCaseImpl(mockBulkLawsRepository,
          mockLawRepository, mockLawYearRepository, mockLawMenuOrderRepository);
    });

    test('should execute the use case', () async {
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll())
          .thenAnswer((_) => Future.value(null));
      when(mockLawMenuOrderRepository.fetchFromRemote())
          .thenAnswer((_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));
      when(mockLawMenuOrderRepository.saveToLocal(any))
          .thenAnswer((_) => Future.value(null));
      when(mockBulkLawsRepository.getFileReference(any, any))
          .thenAnswer((_) => Future.value([File('1'), File('2')]));
      when(mockBulkLawsRepository.downloadLaw(any, any))
          .thenAnswer((_) => Future.value(null));
      when(mockBulkLawsRepository.decodeFile(
              argThat(isA<File>().having((e) => e.path, 'path', '1'))))
          .thenAnswer((_) => Future.value(
              [LawEntity(1, '1', 1, null, null, null, null, '1', null)]));
      when(mockBulkLawsRepository.decodeFile(
              argThat(isA<File>().having((e) => e.path, 'path', '2'))))
          .thenAnswer((_) => Future.value(
              [LawEntity(2, '2', 2, null, null, null, null, '1', null)]));
      when(mockLawRepository.addAll(any)).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.addAll(any))
          .thenAnswer((_) => Future.value(null));

      await useCase
          .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3'));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);

      verify(mockLawMenuOrderRepository.fetchFromRemote()).called(1);
      expect(
          verify(mockLawMenuOrderRepository.saveToLocal(captureAny)).captured, [
        [
          isA<LawMenuOrderEntity>()
              .having((e) => e.id, 'id', '1')
              .having((e) => e.name, 'name', '1')
              .having((e) => e.order, 'order', 1)
        ]
      ]);
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
        isA<Map<String, List<LawYearEntity>>>()
            .having((map) => map.length, 'length', 1)
            .having((map) => map.keys, 'keys', ['1']).having(
          (map) => map['1'],
          'value at key 1',
          [
            isA<LawYearEntity>()
                .having((e) => e.id, 'id', 0)
                .having((e) => e.year, 'year', 1)
                .having((e) => e.count, 'count', 1),
            isA<LawYearEntity>()
                .having((e) => e.id, 'id', 0)
                .having((e) => e.year, 'year', 2)
                .having((e) => e.count, 'count', 1)
          ],
        )
      ]);
    });

    test('should execute the use case with minimum file execution', () async {
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll())
          .thenAnswer((_) => Future.value(null));
      when(mockLawMenuOrderRepository.fetchFromRemote())
          .thenAnswer((_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));
      when(mockLawMenuOrderRepository.saveToLocal(any))
          .thenAnswer((_) => Future.value(null));
      when(mockBulkLawsRepository.getFileReference(any, any))
          .thenAnswer((_) => Future.value([File('1'), File('2')]));
      when(mockBulkLawsRepository.downloadLaw(any, any))
          .thenAnswer((_) => Future.value(null));
      when(mockBulkLawsRepository.decodeFile(
              argThat(isA<File>().having((e) => e.path, 'path', '1'))))
          .thenAnswer((_) => Future.value(
              [LawEntity(1, '1', 1, null, null, null, null, '1', null)]));
      when(mockBulkLawsRepository.decodeFile(
              argThat(isA<File>().having((e) => e.path, 'path', '2'))))
          .thenAnswer((_) => Future.value(
              [LawEntity(2, '2', 2, null, null, null, null, '1', null)]));
      when(mockLawRepository.addAll(any)).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.addAll(any))
          .thenAnswer((_) => Future.value(null));

      await useCase.execute(VersionEntity(
          VersionDetailEntity(['1', '2', '3', '4', '5']), 2, '3'));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);

      verify(mockLawMenuOrderRepository.fetchFromRemote()).called(1);
      expect(
          verify(mockLawMenuOrderRepository.saveToLocal(captureAny)).captured, [
        [
          isA<LawMenuOrderEntity>()
              .having((e) => e.id, 'id', '1')
              .having((e) => e.name, 'name', '1')
              .having((e) => e.order, 'order', 1)
        ]
      ]);
      expect(
          verify(mockBulkLawsRepository.getFileReference(
                  captureAny, captureAny))
              .captured,
          [
            '2', // id
            ['1', '2', '3', '4', '5'] // filenames
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
        isA<Map<String, List<LawYearEntity>>>()
            .having((map) => map.length, 'length', 1)
            .having((map) => map.keys, 'keys', ['1']).having(
          (map) => map['1'],
          'value at key 1',
          [
            isA<LawYearEntity>()
                .having((e) => e.id, 'id', 0)
                .having((e) => e.year, 'year', 1)
                .having((e) => e.count, 'count', 1),
            isA<LawYearEntity>()
                .having((e) => e.id, 'id', 0)
                .having((e) => e.year, 'year', 2)
                .having((e) => e.count, 'count', 1)
          ],
        )
      ]);
    });

    test('should execute the use case with minimum filename execution',
        () async {
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll())
          .thenAnswer((_) => Future.value(null));
      when(mockLawMenuOrderRepository.fetchFromRemote())
          .thenAnswer((_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));
      when(mockLawMenuOrderRepository.saveToLocal(any))
          .thenAnswer((_) => Future.value(null));
      when(mockBulkLawsRepository.getFileReference(any, any)).thenAnswer((_) =>
          Future.value(
              [File('2'), File('1'), File('3'), File('4'), File('5')]));
      when(mockBulkLawsRepository.downloadLaw(any, any))
          .thenAnswer((_) => Future.value(null));
      when(mockBulkLawsRepository.decodeFile(
              argThat(isA<File>().having((e) => e.path, 'path', '1'))))
          .thenAnswer((_) => Future.value(
              [LawEntity(1, '1', 1, null, null, null, null, '1', null)]));
      when(mockBulkLawsRepository.decodeFile(
              argThat(isA<File>().having((e) => e.path, 'path', '2'))))
          .thenAnswer((_) => Future.value(
              [LawEntity(2, '2', 2, null, null, null, null, '1', null)]));
      when(mockLawRepository.addAll(any)).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.addAll(any))
          .thenAnswer((_) => Future.value(null));

      await useCase
          .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3'));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);

      verify(mockLawMenuOrderRepository.fetchFromRemote()).called(1);
      expect(
          verify(mockLawMenuOrderRepository.saveToLocal(captureAny)).captured, [
        [
          isA<LawMenuOrderEntity>()
              .having((e) => e.id, 'id', '1')
              .having((e) => e.name, 'name', '1')
              .having((e) => e.order, 'order', 1)
        ]
      ]);
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
            isA<File>().having((e) => e.path, 'path', '2'),
            '2',
            isA<File>().having((e) => e.path, 'path', '1')
          ]);

      expect(verify(mockBulkLawsRepository.decodeFile(captureAny)).captured, [
        isA<File>().having((e) => e.path, 'path', '2'),
        isA<File>().having((e) => e.path, 'path', '1')
      ]);

      expect(verify(mockLawRepository.addAll(captureAny)).captured, [
        [
          isA<LawEntity>()
              .having((e) => e.id, 'id', 2)
              .having((e) => e.remoteId, 'remoteId', '2')
              .having((e) => e.year, 'year', 2)
        ],
        [
          isA<LawEntity>()
              .having((e) => e.id, 'id', 1)
              .having((e) => e.remoteId, 'remoteId', '1')
              .having((e) => e.year, 'year', 1)
        ]
      ]);

      expect(verify(mockLawYearRepository.addAll(captureAny)).captured, [
        isA<Map<String, List<LawYearEntity>>>()
            .having((map) => map.length, 'length', 1)
            .having((map) => map.keys, 'keys', ['1']).having(
          (map) => map['1'],
          'value at key 1',
          [
            isA<LawYearEntity>()
                .having((e) => e.id, 'id', 0)
                .having((e) => e.year, 'year', 2)
                .having((e) => e.count, 'count', 1),
            isA<LawYearEntity>()
                .having((e) => e.id, 'id', 0)
                .having((e) => e.year, 'year', 1)
                .having((e) => e.count, 'count', 1)
          ],
        ),
      ]);
    });

    test('thrown an error if milis is null', () async {
      await expectLater(useCase.execute(VersionEntity(null, null, null)),
          throwsA(isA<DataFetchFailureException>()));

      verifyNever(mockLawRepository.deleteAll());
      verifyNever(mockLawYearRepository.deleteAll());
      verifyNever(mockLawMenuOrderRepository.fetchFromRemote());
      verifyNever(mockLawMenuOrderRepository.saveToLocal(any));
      verifyNever(mockBulkLawsRepository.getFileReference(any, any));
      verifyNever(mockBulkLawsRepository.downloadLaw(any, any));
      verifyNever(mockBulkLawsRepository.decodeFile(any));
      verifyNever(mockLawRepository.addAll(any));
      verifyNever(mockLawYearRepository.addAll(any));
    });

    test('thrown an error from law delete all', () async {
      when(mockLawRepository.deleteAll()).thenAnswer(
          (_) => Future.error(DefinedException(null, null, '1', '2')));

      await expectLater(
          useCase
              .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3')),
          throwsA(isA<DefinedException>()
              .having((e) => e.code, 'code', '1')
              .having((e) => e.message, 'message', '2')));

      verify(mockLawRepository.deleteAll()).called(1);

      verifyNever(mockLawYearRepository.deleteAll());
      verifyNever(mockLawMenuOrderRepository.fetchFromRemote());
      verifyNever(mockLawMenuOrderRepository.saveToLocal(any));
      verifyNever(mockBulkLawsRepository.getFileReference(any, any));
      verifyNever(mockBulkLawsRepository.downloadLaw(any, any));
      verifyNever(mockBulkLawsRepository.decodeFile(any));
      verifyNever(mockLawRepository.addAll(any));
      verifyNever(mockLawYearRepository.addAll(any));
    });

    test('thrown an error from law year delete all', () async {
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll()).thenAnswer(
          (_) => Future.error(DefinedException(null, null, '1', '2')));

      await expectLater(
          useCase
              .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3')),
          throwsA(isA<DefinedException>()
              .having((e) => e.code, 'code', '1')
              .having((e) => e.message, 'message', '2')));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);

      verifyNever(mockLawMenuOrderRepository.fetchFromRemote());
      verifyNever(mockLawMenuOrderRepository.saveToLocal(any));
      verifyNever(mockBulkLawsRepository.getFileReference(any, any));
      verifyNever(mockBulkLawsRepository.downloadLaw(any, any));
      verifyNever(mockBulkLawsRepository.decodeFile(any));
      verifyNever(mockLawRepository.addAll(any));
      verifyNever(mockLawYearRepository.addAll(any));
    });

    test('thrown an error from fetch law order from remote', () async {
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll())
          .thenAnswer((_) => Future.value(null));
      when(mockLawMenuOrderRepository.fetchFromRemote()).thenAnswer(
          (_) => Future.error(DefinedException(null, null, '1', '2')));

      await expectLater(
          useCase
              .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3')),
          throwsA(isA<DefinedException>()
              .having((e) => e.code, 'code', '1')
              .having((e) => e.message, 'message', '2')));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);
      verify(mockLawMenuOrderRepository.fetchFromRemote()).called(1);

      verifyNever(mockLawMenuOrderRepository.saveToLocal(any));
      verifyNever(mockBulkLawsRepository.getFileReference(any, any));
      verifyNever(mockBulkLawsRepository.downloadLaw(any, any));
      verifyNever(mockBulkLawsRepository.decodeFile(any));
      verifyNever(mockLawRepository.addAll(any));
      verifyNever(mockLawYearRepository.addAll(any));
    });

    test('thrown an error from save law order', () async {
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll())
          .thenAnswer((_) => Future.value(null));
      when(mockLawMenuOrderRepository.fetchFromRemote())
          .thenAnswer((_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));
      when(mockLawMenuOrderRepository.saveToLocal(any)).thenAnswer(
          (_) => Future.error(DefinedException(null, null, '1', '2')));

      await expectLater(
          useCase
              .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3')),
          throwsA(isA<DefinedException>()
              .having((e) => e.code, 'code', '1')
              .having((e) => e.message, 'message', '2')));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);
      verify(mockLawMenuOrderRepository.fetchFromRemote()).called(1);
      verify(mockLawMenuOrderRepository.saveToLocal(any)).called(1);

      verifyNever(mockBulkLawsRepository.getFileReference(any, any));
      verifyNever(mockBulkLawsRepository.downloadLaw(any, any));
      verifyNever(mockBulkLawsRepository.decodeFile(any));
      verifyNever(mockLawRepository.addAll(any));
      verifyNever(mockLawYearRepository.addAll(any));
    });

    test('thrown an error from get file reference', () async {
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll())
          .thenAnswer((_) => Future.value(null));
      when(mockLawMenuOrderRepository.fetchFromRemote())
          .thenAnswer((_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));
      when(mockLawMenuOrderRepository.saveToLocal(any))
          .thenAnswer((_) => Future.value(null));
      when(mockBulkLawsRepository.getFileReference(any, any)).thenAnswer(
          (_) => Future.error(DefinedException(null, null, '1', '2')));

      await expectLater(
          useCase
              .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3')),
          throwsA(isA<DefinedException>()
              .having((e) => e.code, 'code', '1')
              .having((e) => e.message, 'message', '2')));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);
      verify(mockLawMenuOrderRepository.fetchFromRemote()).called(1);
      verify(mockLawMenuOrderRepository.saveToLocal(any)).called(1);
      verify(mockBulkLawsRepository.getFileReference(any, any)).called(1);

      verifyNever(mockBulkLawsRepository.downloadLaw(any, any));
      verifyNever(mockBulkLawsRepository.decodeFile(any));
      verifyNever(mockLawRepository.addAll(any));
      verifyNever(mockLawYearRepository.addAll(any));
    });

    test('thrown an error from download law', () async {
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll())
          .thenAnswer((_) => Future.value(null));
      when(mockLawMenuOrderRepository.fetchFromRemote())
          .thenAnswer((_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));
      when(mockLawMenuOrderRepository.saveToLocal(any))
          .thenAnswer((_) => Future.value(null));
      when(mockBulkLawsRepository.getFileReference(any, any))
          .thenAnswer((_) => Future.value([File('1'), File('2')]));
      when(mockBulkLawsRepository.downloadLaw(any, any)).thenAnswer(
          (_) => Future.error(DefinedException(null, null, '1', '2')));

      await expectLater(
          useCase
              .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3')),
          throwsA(isA<DefinedException>()
              .having((e) => e.code, 'code', '1')
              .having((e) => e.message, 'message', '2')));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);
      verify(mockLawMenuOrderRepository.fetchFromRemote()).called(1);
      verify(mockLawMenuOrderRepository.saveToLocal(any)).called(1);
      verify(mockBulkLawsRepository.getFileReference(any, any)).called(1);
      verify(mockBulkLawsRepository.downloadLaw(any, any)).called(1);

      verifyNever(mockBulkLawsRepository.decodeFile(any));
      verifyNever(mockLawRepository.addAll(any));
      verifyNever(mockLawYearRepository.addAll(any));
    });

    test('thrown an error from decode law', () async {
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll())
          .thenAnswer((_) => Future.value(null));
      when(mockLawMenuOrderRepository.fetchFromRemote())
          .thenAnswer((_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));
      when(mockLawMenuOrderRepository.saveToLocal(any))
          .thenAnswer((_) => Future.value(null));
      when(mockBulkLawsRepository.getFileReference(any, any))
          .thenAnswer((_) => Future.value([File('1'), File('2')]));
      when(mockBulkLawsRepository.downloadLaw(any, any))
          .thenAnswer((_) => Future.value(null));
      when(mockBulkLawsRepository.decodeFile(any)).thenAnswer(
          (_) => Future.error(DefinedException(null, null, '1', '2')));

      await expectLater(
          useCase
              .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3')),
          throwsA(isA<DefinedException>()
              .having((e) => e.code, 'code', '1')
              .having((e) => e.message, 'message', '2')));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);
      verify(mockLawMenuOrderRepository.fetchFromRemote()).called(1);
      verify(mockLawMenuOrderRepository.saveToLocal(any)).called(1);
      verify(mockBulkLawsRepository.getFileReference(any, any)).called(1);
      verify(mockBulkLawsRepository.downloadLaw(any, any)).called(1);
      verify(mockBulkLawsRepository.decodeFile(any)).called(1);

      verifyNever(mockLawRepository.addAll(any));
      verifyNever(mockLawYearRepository.addAll(any));
    });

    test('thrown an error from add law', () async {
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll())
          .thenAnswer((_) => Future.value(null));
      when(mockLawMenuOrderRepository.fetchFromRemote())
          .thenAnswer((_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));
      when(mockLawMenuOrderRepository.saveToLocal(any))
          .thenAnswer((_) => Future.value(null));
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
      when(mockLawRepository.addAll(any)).thenAnswer(
          (_) => Future.error(DefinedException(null, null, '1', '2')));

      await expectLater(
          useCase
              .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3')),
          throwsA(isA<DefinedException>()
              .having((e) => e.code, 'code', '1')
              .having((e) => e.message, 'message', '2')));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);
      verify(mockLawMenuOrderRepository.fetchFromRemote()).called(1);
      verify(mockLawMenuOrderRepository.saveToLocal(any)).called(1);
      verify(mockBulkLawsRepository.getFileReference(any, any)).called(1);
      verify(mockBulkLawsRepository.downloadLaw(any, any)).called(1);
      verify(mockBulkLawsRepository.decodeFile(any)).called(1);
      verify(mockLawRepository.addAll(any)).called(1);

      verifyNever(mockLawYearRepository.addAll(any));
    });

    test('thrown an error from add law year', () async {
      when(mockLawRepository.deleteAll()).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.deleteAll())
          .thenAnswer((_) => Future.value(null));
      when(mockLawMenuOrderRepository.fetchFromRemote())
          .thenAnswer((_) => Future.value([LawMenuOrderEntity('1', '1', 1)]));
      when(mockLawMenuOrderRepository.saveToLocal(any))
          .thenAnswer((_) => Future.value(null));
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
      when(mockLawRepository.addAll(any)).thenAnswer((_) => Future.value(null));
      when(mockLawYearRepository.addAll(any)).thenAnswer(
          (_) => Future.error(DefinedException(null, null, '1', '2')));

      await expectLater(
          useCase
              .execute(VersionEntity(VersionDetailEntity(['1', '2']), 2, '3')),
          throwsA(isA<DefinedException>()
              .having((e) => e.code, 'code', '1')
              .having((e) => e.message, 'message', '2')));

      verify(mockLawRepository.deleteAll()).called(1);
      verify(mockLawYearRepository.deleteAll()).called(1);
      verify(mockLawMenuOrderRepository.fetchFromRemote()).called(1);
      verify(mockLawMenuOrderRepository.saveToLocal(any)).called(1);
      verify(mockBulkLawsRepository.getFileReference(any, any)).called(1);
      verify(mockBulkLawsRepository.downloadLaw(any, any)).called(2);
      verify(mockBulkLawsRepository.decodeFile(any)).called(2);
      verify(mockLawRepository.addAll(any)).called(2);
      verify(mockLawYearRepository.addAll(any)).called(1);
    });
  });
}
