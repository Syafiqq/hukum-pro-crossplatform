import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_year_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_year_entity.dart'
as DataLawYearEntity;
import 'package:hukum_pro/arch/data/repository/law_year_repository_impl.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'law_year_repository_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<LawYearLocalDatasource>(
      as: #BaseMockLawYearLocalDatasource, returnNullOnMissingStub: true),
])
void main() {
  group('$LawYearRepository', () {
    late BaseMockLawYearLocalDatasource mockLawYearLocalDatasource;
    late LawYearRepositoryImpl repository;

    setUp(() {
      mockLawYearLocalDatasource = BaseMockLawYearLocalDatasource();
      repository = LawYearRepositoryImpl(mockLawYearLocalDatasource);
    });

    group('deleteAll', () {
      test('it should call datasource deleteAllLawYear', () async {
        when(mockLawYearLocalDatasource.deleteAllLawYear())
            .thenAnswer((realInvocation) => Future.value(null));

        await repository.deleteAll();

        verify(mockLawYearLocalDatasource.deleteAllLawYear()).called(1);
      });
    });

    group('addAll', () {
      test('it should call datasource addLaws', () async {
        var entities = [0, 1].map((e) => LawYearEntity(1, 1, 1)).toList();

        when(mockLawYearLocalDatasource.addLawYears(any))
            .thenAnswer((realInvocation) => Future.value(null));

        await repository.addAll(entities);

        verify(mockLawYearLocalDatasource.addLawYears(
                entities.map((e) => e.toData()).toList(growable: false)))
            .called(1);
      });
    });

    group('get', () {
      test('it should call datasource getLawYearsWithPagination', () async {
        when(mockLawYearLocalDatasource.getLawYearsWithPagination(any, any))
            .thenAnswer((realInvocation) => Future.value([]));

        await repository.get(1, 1);

        verify(mockLawYearLocalDatasource.getLawYearsWithPagination(1, 1))
            .called(1);
      });
    });

    group('getById', () {
      test('it should call datasource getLawById', () async {
        when(mockLawYearLocalDatasource.getLawYearById(any))
            .thenAnswer((realInvocation) => Future.value(null));

        await repository.getById(1);

        verify(mockLawYearLocalDatasource.getLawYearById(1)).called(1);
      });
    });

    group('Codable', () {
      group('$LawYearEntity', () {
        group('toData', () {
          test('it should change to data model', () {
            var domainModel = LawYearEntity(999, 1, 2);

            var dataModel = domainModel.toData();

            expect(dataModel.id, 0);
            expect(dataModel.year, 1);
            expect(dataModel.count, 2);
          });
        });
      });

      group('DataLawYearEntity.LawYearEntity', () {
        group('toDomain', () {
          test('it should change to data model', () {
            var dataModel = DataLawYearEntity.LawYearEntity()
              ..year = 2
              ..count = 3;

            var domainModel = dataModel.toDomain();

            expect(domainModel.id, 0);
            expect(domainModel.year, 2);
            expect(domainModel.count, 3);
          });
        });
      });
    });
  });
}
