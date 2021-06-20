import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';

abstract class LawYearRepository {
  Future<void> deleteAll();
  Future<void> addAll(List<LawYearEntity> laws);
  Future<List<LawYearEntity>> get(int limit, int page);
  Future<LawYearEntity?> getById(int id);
}
