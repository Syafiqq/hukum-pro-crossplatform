import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';

abstract class LawLocalDatasource {
  Future<void> clear();
  Future<void> addLaws(List<LawEntity> laws);
}
