import 'package:hukum_pro/arch/data/data_source/local/entity/law_entity.dart';

abstract class LawLocalDatasource {
  Future<void> deleteAllLaw();

  Future<void> addLaws(List<LawEntity> laws);

  Future<List<LawEntity>> getLawsByYear(int year);

  Future<List<LawEntity>> getLawsByYearWithPagination(
      int year, int limit, int page);

  Future<LawEntity?> getLawById(int id);

  Future<LawEntity?> getLawByRemoteId(String remoteId);
}
