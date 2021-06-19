import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/repository/law_repository_impl.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'law_repository_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<LawLocalDatasource>(
      as: #BaseMockLawLocalDatasource, returnNullOnMissingStub: true),
])
void main() {
  group('$LawRepository', () {
    late BaseMockLawLocalDatasource mockLawLocalDatasource;
    late LawRepositoryImpl repository;

    setUp(() {
      mockLawLocalDatasource = BaseMockLawLocalDatasource();
      repository = LawRepositoryImpl(mockLawLocalDatasource);
    });

    group('deleteAll', () {
      test('it should call datasource deleteAllLaw', () async {
        when(mockLawLocalDatasource.deleteAllLaw())
            .thenAnswer((realInvocation) => Future.value(null));

        await repository.deleteAll();

        verify(mockLawLocalDatasource.deleteAllLaw()).called(1);
      });
    });

    group('addAll', () {
      test('it should call datasource addLaws', () async {
        var entities = [0, 1]
            .map((e) => LawEntity(
                e, e.toString(), e, null, null, null, null, null, null))
            .toList();

        when(mockLawLocalDatasource.addLaws(any))
            .thenAnswer((realInvocation) => Future.value(null));

        await repository.addAll(entities);

        verify(mockLawLocalDatasource.addLaws(
                entities.map((e) => e.toData()).toList(growable: false)))
            .called(1);
      });
    });

    group('getByYear', () {
      test('it should call datasource getLawsByYearWithPagination', () async {
        when(mockLawLocalDatasource.getLawsByYearWithPagination(any, any, any))
            .thenAnswer((realInvocation) => Future.value([]));

        await repository.getByYear(1, 1, 1);

        verify(mockLawLocalDatasource.getLawsByYearWithPagination(1, 1, 1))
            .called(1);
      });
    });

    group('getById', () {
      test('it should call datasource getLawById', () async {
        when(mockLawLocalDatasource.getLawById(any))
            .thenAnswer((realInvocation) => Future.value(null));

        await repository.getById(1);

        verify(mockLawLocalDatasource.getLawById(1)).called(1);
      });
    });

    group('getByRemoteId', () {
      test('it should call datasource getLawByRemoteId', () async {
        when(mockLawLocalDatasource.getLawByRemoteId(any))
            .thenAnswer((realInvocation) => Future.value(null));

        await repository.getByRemoteId('1');

        verify(mockLawLocalDatasource.getLawByRemoteId('1')).called(1);
      });
    });
  });
}
