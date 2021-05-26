import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';

abstract class BulkLawsLocalDatasource {
  Future<void> clear();
  Future<void> addLaws(List<LawEntity> laws);
}
