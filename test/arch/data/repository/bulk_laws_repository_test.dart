import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/bulk_laws_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/bulk_laws_remote_datasource.dart';
import 'package:hukum_pro/arch/data/repository/bulk_laws_repository_impl.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:hukum_pro/common/exception/defined_exception.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';

import 'bulk_laws_repository_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<BulkLawsRemoteDatasource>(
      as: #BaseMockBulkLawsRemoteDatasource, returnNullOnMissingStub: true),
  MockSpec<BulkLawsLocalDatasource>(
      as: #BaseMockBulkLawsLocalDatasource, returnNullOnMissingStub: true)
])
void main() {
  group('$BulkLawsRepository', () {
    late BaseMockBulkLawsRemoteDatasource mockBulkLawsRemoteDatasource;
    late BaseMockBulkLawsLocalDatasource mockBulkLawsLocalDatasource;
    late BulkLawsRepository repository;

    setUp(() {
      mockBulkLawsRemoteDatasource = BaseMockBulkLawsRemoteDatasource();
      mockBulkLawsLocalDatasource = BaseMockBulkLawsLocalDatasource();
      repository = BulkLawsRepositoryImpl(
          mockBulkLawsRemoteDatasource, mockBulkLawsLocalDatasource);
    });

    group('getFileReference', () {
      test('return files', () async {
        when(mockBulkLawsLocalDatasource.getBulkLawDiskReferences(any, any))
            .thenAnswer((e) async {
          var path = e.positionalArguments[0] as String;
          var names = e.positionalArguments[1] as List<String>;
          return names.map((e) => File('/$path/$e')).toList();
        });

        var files = await repository
            .getFileReference('1', ['1.json', '2.json', '3.json']);
        expect(files, <Matcher>[
          isA<File>()
              .having((e) => e.path, 'path 1', contains('/1/'))
              .having((e) => e.path, 'path 2', contains('/1.json')),
          isA<File>()
              .having((e) => e.path, 'path 1', contains('/1/'))
              .having((e) => e.path, 'path 2', contains('/2.json')),
          isA<File>()
              .having((e) => e.path, 'path 1', contains('/1/'))
              .having((e) => e.path, 'path 2', contains('/3.json')),
        ]);
      });

      test('throws error', () async {
        when(mockBulkLawsLocalDatasource.getBulkLawDiskReferences(any, any))
            .thenAnswer((_) => Future.error(DataLocationNotFoundException(
                MissingPlatformDirectoryException('1'), null)));

        await expectLater(
            repository.getFileReference('1', [
              '1.json',
            ]),
            throwsA(isA<DataLocationNotFoundException>().having(
                (e) => e.internalException,
                'internalException',
                isA<MissingPlatformDirectoryException>())));
      });
    });
    group('downloadLaw', () {
      test('download complete', () async {
        when(mockBulkLawsRemoteDatasource.downloadBulkLaws(any, any))
            .thenAnswer((_) async => null);

        await repository.downloadLaw('1.json', File('a.json'));
      });

      test('throws error from firebase', () async {
        when(mockBulkLawsRemoteDatasource.downloadBulkLaws(any, any))
            .thenAnswer((_) => Future.error(DataFetchFailureException(
                FirebaseException(plugin: '1'), null)));

        await expectLater(
            repository.downloadLaw('1.json', File('a.json')),
            throwsA(isA<DataFetchFailureException>().having(
                (e) => e.internalException,
                'internalException',
                isA<FirebaseException>()
                    .having((e) => e.plugin, 'plugin', '1'))));
      });

      test('throws error from filesystem', () async {
        when(mockBulkLawsRemoteDatasource.downloadBulkLaws(any, any))
            .thenAnswer((_) => Future.error(
                DataFetchFailureException(FileSystemException('1'), null)));

        await expectLater(
            repository.downloadLaw('1.json', File('a.json')),
            throwsA(isA<DataFetchFailureException>().having(
                (e) => e.internalException,
                'internalException',
                isA<FileSystemException>()
                    .having((e) => e.message, 'message', '1'))));
      });
    });

    group('decodeFile', () {
      test('success decode', () async {
        when(mockBulkLawsLocalDatasource.decodeBulkLaw(any)).thenAnswer((_) =>
            Future.value([0, 1]
                .map((e) => LawEntity(
                    e, e.toString(), e, null, null, null, null, null, null))
                .toList()));

        final file = File('');
        final response = await repository.decodeFile(file);

        verify(mockBulkLawsLocalDatasource.decodeBulkLaw(file)).called(1);

        expect(response.length, 2);
        expect(response.first.id, 0);
        expect(response.first.remoteId, '0');
        expect(response.first.year, 0);
      });

      test('throws error', () async {
        when(mockBulkLawsLocalDatasource.decodeBulkLaw(any)).thenAnswer(
            (realInvocation) =>
                Future.error(DefinedException(null, null, '1', '2')));

        final file = File('');
        await expectLater(
            repository.decodeFile(file),
            throwsA(isA<DefinedException>()
                .having((e) => e.code, 'code', '1')
                .having((e) => e.message, 'message', '2')));

        verify(mockBulkLawsLocalDatasource.decodeBulkLaw(file)).called(1);
      });
    });
  });
}
