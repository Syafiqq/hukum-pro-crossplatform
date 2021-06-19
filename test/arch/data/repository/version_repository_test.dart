import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/version_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/data/repository/version_repository_impl.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'version_repository_test.mocks.dart';

@GenerateMocks([VersionRemoteDatasource, VersionLocalDatasource])
void main() {
  group('$VersionRepository', () {
    late VersionRemoteDatasource mockVersionRemoteDatasource;
    late VersionLocalDatasource mockVersionCacheDatasource;
    late VersionRepositoryImpl repository;

    setUp(() {
      mockVersionRemoteDatasource = MockVersionRemoteDatasource();
      mockVersionCacheDatasource = MockVersionLocalDatasource();
      repository = VersionRepositoryImpl(
          mockVersionRemoteDatasource, mockVersionCacheDatasource);
    });

    group('fetchFromRemote', () {
      test('success get version', () async {
        when(mockVersionRemoteDatasource.getVersion())
            .thenAnswer((_) async => VersionEntity(null, null, null));

        expect(await mockVersionRemoteDatasource.getVersion(), isNotNull);

        var version = await repository.fetchFromRemote();
        expect(version, isNotNull);
        expect(version.detail, isNull);
        expect(version.milis, isNull);
        expect(version.timestamp, isNull);
      });

      test('throw data not exists', () async {
        when(mockVersionRemoteDatasource.getVersion())
            .thenThrow(DataNotExistsException(null, null));

        try {
          await mockVersionRemoteDatasource.getVersion();
          fail('must not be executed');
        } catch (e) {
          expect(e, isA<DataNotExistsException>());
        }

        await expectLater(repository.fetchFromRemote(),
            throwsA(isA<DataNotExistsException>()));
      });

      test('throw parse failed', () async {
        when(mockVersionRemoteDatasource.getVersion())
            .thenThrow(ParseFailedException(VersionEntity, null, null));

        try {
          await mockVersionRemoteDatasource.getVersion();
          fail('must not be executed');
        } catch (e) {
          expect(e, isA<ParseFailedException>());
        }

        await expectLater(
            repository.fetchFromRemote(), throwsA(isA<ParseFailedException>()));
      });
    });

    group('fetchFromLocal', () {
      test('get null version', () async {
        when(mockVersionCacheDatasource.getVersion())
            .thenAnswer((_) async => null);

        expect(await mockVersionCacheDatasource.getVersion(), isNull);

        var version = await repository.fetchFromLocal();
        expect(version, isNull);
      });

      test('get version', () async {
        when(mockVersionCacheDatasource.getVersion())
            .thenAnswer((_) async => VersionEntity(null, null, null));

        await expectLater(mockVersionCacheDatasource.getVersion(), isNotNull);

        var version = await repository.fetchFromLocal();
        expect(version, isNotNull);
        expect(version?.detail, isNull);
        expect(version?.milis, isNull);
        expect(version?.timestamp, isNull);
      });

      test('throw parse failed', () async {
        when(mockVersionCacheDatasource.getVersion())
            .thenThrow(ParseFailedException(VersionEntity, null, null));

        try {
          await mockVersionCacheDatasource.getVersion();
          fail('must not be executed');
        } catch (e) {
          expect(e, isA<ParseFailedException>());
        }

        await expectLater(
            repository.fetchFromLocal(), throwsA(isA<ParseFailedException>()));
      });
    });

    group('saveToLocal', () {
      test('set version', () async {
        var entity = VersionEntity(null, null, null);
        when(mockVersionCacheDatasource.setVersion(entity))
            .thenAnswer((_) async {});

        verifyNever(mockVersionCacheDatasource.setVersion(entity));

        await repository.saveToLocal(entity);

        verify(mockVersionCacheDatasource.setVersion(entity)).called(1);
      });
    });
  });
}
