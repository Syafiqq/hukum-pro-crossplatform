import 'package:hukum_pro/arch/data/data_source/local/entity/law_year_entity.dart';

abstract class LawYearLocalDatasource {
  Future<void> addLawYears(List<LawYearEntity> laws);

  Future<List<LawYearEntity>> getLawYearsWithPagination(int limit, int page);

  Future<LawYearEntity?> getLawYearByYear(int year);

  Future<LawYearEntity?> getLawYearById(int id);

  Future<void> deleteAllLawYear();
}
