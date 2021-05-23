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
    late VersionRepositoryImpl versionRepository;

    setUp(() {
      mockVersionRemoteDatasource = MockVersionRemoteDatasource();
      mockVersionCacheDatasource = MockVersionLocalDatasource();
      versionRepository = VersionRepositoryImpl(
          mockVersionRemoteDatasource, mockVersionCacheDatasource);
    });

    group('fetchFromRemote', () {
      test('success get version', () async {
        when(mockVersionRemoteDatasource.getVersion())
            .thenAnswer((_) async => VersionEntity(null, null, null));

        expect(await mockVersionRemoteDatasource.getVersion(), isNotNull);

        var version = await versionRepository.fetchFromRemote();
        expect(version, isNotNull);
        expect(version.detail, isNull);
        expect(version.milis, isNull);
        expect(version.timestamp, isNull);
      });

      test('throw data not exists', () async {
        when(mockVersionRemoteDatasource.getVersion())
            .thenThrow(DataNotExistsException(null, null));

        expect(() async => await mockVersionRemoteDatasource.getVersion(),
            throwsA(isA<DataNotExistsException>()));

        expect(() async => await versionRepository.fetchFromRemote(),
            throwsA(isA<DataNotExistsException>()));
      });

      test('throw parse failed', () async {
        when(mockVersionRemoteDatasource.getVersion())
            .thenThrow(ParseFailedException(VersionEntity, null, null));

        expect(() async => await mockVersionRemoteDatasource.getVersion(),
            throwsA(isA<ParseFailedException>()));

        expect(() async => await versionRepository.fetchFromRemote(),
            throwsA(isA<ParseFailedException>()));
      });
    });

    group('fetchFromLocal', () {
      test('get null version', () async {
        when(mockVersionCacheDatasource.getVersion())
            .thenAnswer((_) async => null);

        expect(await mockVersionCacheDatasource.getVersion(), isNull);

        var version = await versionRepository.fetchFromLocal();
        expect(version, isNull);
      });

      test('get version', () async {
        when(mockVersionCacheDatasource.getVersion())
            .thenAnswer((_) async => VersionEntity(null, null, null));

        expect(() async => await mockVersionCacheDatasource.getVersion(),
            isNotNull);

        var version = await versionRepository.fetchFromLocal();
        expect(version, isNotNull);
        expect(version?.detail, isNull);
        expect(version?.milis, isNull);
        expect(version?.timestamp, isNull);
      });

      test('throw parse failed', () async {
        when(mockVersionCacheDatasource.getVersion())
            .thenThrow(ParseFailedException(VersionEntity, null, null));

        expect(() async => await mockVersionCacheDatasource.getVersion(),
            throwsA(isA<ParseFailedException>()));

        expect(() async => await versionRepository.fetchFromLocal(),
            throwsA(isA<ParseFailedException>()));
      });
    });

    group('saveToLocal', () {
      test('set version', () async {
        var entity = VersionEntity(null, null, null);
        when(mockVersionCacheDatasource.setVersion(entity))
            .thenAnswer((_) async {});

        verifyNever(mockVersionCacheDatasource.setVersion(entity));

        await versionRepository.saveToLocal(entity);

        verify(mockVersionCacheDatasource.setVersion(entity)).called(1);
      });
    });
  });
}
