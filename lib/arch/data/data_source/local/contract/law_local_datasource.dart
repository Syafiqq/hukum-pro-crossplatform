import 'package:hukum_pro/arch/data/data_source/local/entity/law_entity.dart';
import 'package:hukum_pro/objectbox.g.dart';

abstract class LawLocalDatasource {
  set store(Store store) {}
  Future<void> clear();
  Future<void> addLaws(List<LawEntity> laws);
}
