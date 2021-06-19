import 'package:hukum_pro/arch/data/data_source/local/entity/law_entity.dart';

abstract class LawLocalDatasource {
  Future<void> clear();
  Future<void> addLaws(List<LawEntity> laws);
  Future<List<LawEntity>> getLawsByYear(int year);
}
