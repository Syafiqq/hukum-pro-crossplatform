import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/entity/version/check_local_version_state.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case_impl.dart';
import 'package:hukum_pro/common/exception/defined_exception.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'check_version_first_time_use_case_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<VersionRepository>(
      as: #BaseMockVersionRepository, returnNullOnMissingStub: true),
])
void main() {
  group('$CheckVersionFirstTimeUseCase', () {
    late BaseMockVersionRepository mockVersionRepository;
    late CheckVersionFirstTimeUseCase useCase;

    setUp(() {
      mockVersionRepository = BaseMockVersionRepository();
      useCase = CheckVersionFirstTimeUseCaseImpl(mockVersionRepository);
    });

    test('it should return local version present', () async {
      when(mockVersionRepository.fetchFromLocal())
          .thenAnswer((_) => Future.value(VersionEntity(null, null, null)));

      var version = await useCase.execute();

      expect(
          version,
          isA<LocalVersionPresent>().having(
              (e) => e.version,
              'version',
              isA<VersionEntity>()
                  .having((v) => v.detail, 'detail', isNull)
                  .having((v) => v.milis, 'milis', isNull)
                  .having((v) => v.timestamp, 'timestamp', isNull)));

      verify(mockVersionRepository.fetchFromLocal()).called(1);
      verifyNever(mockVersionRepository.fetchFromRemote());
    });

    test('it should return remote version present', () async {
      when(mockVersionRepository.fetchFromLocal())
          .thenAnswer((_) => Future.value(null));
      when(mockVersionRepository.fetchFromRemote())
          .thenAnswer((_) => Future.value(VersionEntity(null, null, null)));

      var version = await useCase.execute();

      expect(
          version,
          isA<LocalVersionNeedInitialize>().having(
              (e) => e.version,
              'version',
              isA<VersionEntity>()
                  .having((v) => v.detail, 'detail', isNull)
                  .having((v) => v.milis, 'milis', isNull)
                  .having((v) => v.timestamp, 'timestamp', isNull)));

      verify(mockVersionRepository.fetchFromLocal()).called(1);
      verify(mockVersionRepository.fetchFromRemote()).called(1);
    });

    test('it should throw an error from local fetch', () async {
      when(mockVersionRepository.fetchFromLocal())
          .thenThrow(DefinedException(null, null, '1', '2'));

      await expectLater(
          useCase.execute(),
          throwsA(isA<DefinedException>()
              .having((e) => e.code, 'code', '1')
              .having((e) => e.message, 'message', '2')));

      verify(mockVersionRepository.fetchFromLocal()).called(1);
      verifyNever(mockVersionRepository.fetchFromRemote());
    });

    test('it should throw an error from remote fetch', () async {
      when(mockVersionRepository.fetchFromLocal())
          .thenAnswer((_) => Future.value(null));
      when(mockVersionRepository.fetchFromRemote())
          .thenThrow(DefinedException(null, null, '1', '2'));

      await expectLater(
          useCase.execute(),
          throwsA(isA<DefinedException>()
              .having((e) => e.code, 'code', '1')
              .having((e) => e.message, 'message', '2')));

      verify(mockVersionRepository.fetchFromLocal()).called(1);
      verify(mockVersionRepository.fetchFromRemote()).called(1);
    });
  });
}
