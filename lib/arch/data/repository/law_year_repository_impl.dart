import 'package:hukum_pro/arch/data/data_source/local/contract/law_year_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_year_entity.dart'
    as DataLawYearEntity;
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';

class LawYearRepositoryImpl implements LawYearRepository {
  LawYearLocalDatasource localDatasource;

  LawYearRepositoryImpl(this.localDatasource);

  @override
  Future<void> addAll(List<LawYearEntity> laws) async => await localDatasource
      .addLawYears(laws.map((e) => e.toData()).toList(growable: false));

  @override
  Future<void> deleteAll() async => await localDatasource.deleteAllLawYear();

  @override
  Future<LawYearEntity?> getById(int id) async =>
      (await localDatasource.getLawYearById(id))?.toDomain();

  @override
  Future<List<LawYearEntity>> get(int limit, int page) async {
    var laws = await localDatasource.getLawYearsWithPagination(limit, page);
    return laws.map((e) => e.toDomain()).toList();
  }
}

extension DomainCodable on LawYearEntity {
  DataLawYearEntity.LawYearEntity toData() => DataLawYearEntity.LawYearEntity()
    ..year = year
    ..count = count;
}

extension DataCodable on DataLawYearEntity.LawYearEntity {
  LawYearEntity toDomain() => LawYearEntity(id, year, count);
}
