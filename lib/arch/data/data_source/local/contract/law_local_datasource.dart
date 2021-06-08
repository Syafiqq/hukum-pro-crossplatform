import 'package:hukum_pro/arch/data/data_source/local/entity/object_box_law_entity.dart';

abstract class LawLocalDatasource {
  Future<void> clear();
  Future<void> addLaws(List<ObjectBoxLawEntity> laws);
}
