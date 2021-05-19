import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/data/repository/version_repository_impl.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'version_repository_test.mocks.dart';

@GenerateMocks([VersionRemoteDatasource])
void main() {
  group('$VersionRepository', () {
    late VersionRemoteDatasource mockVersionRemoteDatasource;
    late VersionRepositoryImpl versionRepository;

    setUp(() {
      mockVersionRemoteDatasource = MockVersionRemoteDatasource();
      versionRepository = VersionRepositoryImpl(mockVersionRemoteDatasource);
    });

    test('success get version', () async {
      when(mockVersionRemoteDatasource.getVersion())
          .thenAnswer((_) async => VersionEntity(null, null, null));

      expect(() async => await mockVersionRemoteDatasource.getVersion(),
          isNotNull);

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
          throwsA(isInstanceOf<DataNotExistsException>()));

      expect(() async => await versionRepository.fetchFromRemote(),
          throwsA(isInstanceOf<DataNotExistsException>()));
    });

    test('throw parse failed', () async {
      when(mockVersionRemoteDatasource.getVersion())
          .thenThrow(ParseFailedException(VersionEntity, null, null));

      expect(() async => await mockVersionRemoteDatasource.getVersion(),
          throwsA(isInstanceOf<ParseFailedException>()));

      expect(() async => await versionRepository.fetchFromRemote(),
          throwsA(isInstanceOf<ParseFailedException>()));
    });
  });
}
