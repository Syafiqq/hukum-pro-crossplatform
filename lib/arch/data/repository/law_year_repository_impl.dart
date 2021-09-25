import 'package:hukum_pro/arch/data/data_source/local/contract/law_year_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_year_entity.dart'
    as DataLawYearEntity;
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';

class LawYearRepositoryImpl implements LawYearRepository {
  LawYearLocalDatasource localDatasource;

  LawYearRepositoryImpl(this.localDatasource);

  @override
  Future<void> addAll(Map<String, List<LawYearEntity>> laws) async {
    for (var law in laws.entries) {
      await localDatasource.addLawYears(
          law.value.map((e) => e.toData(category: law.key)).toList());
    }
  }

  @override
  Future<void> deleteAll() async => await localDatasource.deleteAllLawYear();

  @override
  Future<LawYearEntity?> getById(int id) async =>
      (await localDatasource.getLawYearById(id))?.toDomain();

  @override
  Future<List<LawYearEntity>> get(String category, int limit, int page) async {
    final laws =
        await localDatasource.getLawYearsWithPagination(category, limit, page);
    return laws.map((e) => e.toDomain()).toList();
  }
}

extension _ExtensionDomainLawYearEntity on LawYearEntity {
  DataLawYearEntity.LawYearEntity toData({String category = ""}) =>
      DataLawYearEntity.LawYearEntity()
        ..year = year
        ..count = count
        ..category = category;
}

extension _ExtensionDataLawYearEntity on DataLawYearEntity.LawYearEntity {
  LawYearEntity toDomain() => LawYearEntity(id, year, count);
}
