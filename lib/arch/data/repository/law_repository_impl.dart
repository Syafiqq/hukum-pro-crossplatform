import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_entity.dart'
    as DataLawEntity;
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';

class LawRepositoryImpl implements LawRepository {
  LawLocalDatasource localDatasource;

  LawRepositoryImpl(this.localDatasource);

  @override
  Future<void> addAll(List<LawEntity> laws) async {
    localDatasource.addLaws(laws.map((e) => e.toData()).toList(growable: false));
  }

  @override
  Future<void> deleteAll() async {
    localDatasource.deleteAllLaw();
  }

  @override
  Future<LawEntity?> getById(int id) async {
    (await localDatasource.getLawById(id))?.toDomain();
  }

  @override
  Future<LawEntity?> getByRemoteId(String remoteId) async {
    (await localDatasource.getLawByRemoteId(remoteId))?.toDomain();
  }

  @override
  Future<List<LawEntity>> getByYear(int year, int limit, int page) async {
    var laws =
        await localDatasource.getLawsByYearWithPagination(year, limit, page);
    return laws.map((e) => e.toDomain()).toList();
  }
}

extension DomainCodable on LawEntity {
  DataLawEntity.LawEntity toData() => DataLawEntity.LawEntity()
    ..remoteId = remoteId
    ..year = year ?? 0
    ..no = no
    ..description = description
    ..status = status
    ..reference = reference
    ..category = category
    ..dateCreated = dateCreated;
}

extension DataCodable on DataLawEntity.LawEntity {
  LawEntity toDomain() => LawEntity(id, remoteId, year, no, description, status,
      reference, category, dateCreated);
}
