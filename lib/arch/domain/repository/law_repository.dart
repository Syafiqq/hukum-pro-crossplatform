import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';

abstract class LawRepository {
  Future<void> deleteAll();
  Future<void> addAll(List<LawEntity> laws);
  Future<List<LawEntity>> getByYear(int year, int limit, int page);
  Future<LawEntity?> getById(int id);
  Future<LawEntity?> getByRemoteId(String remoteId);
}
