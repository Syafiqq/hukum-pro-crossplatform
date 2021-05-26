import 'package:hive/hive.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';

class HiveDatabaseStorage implements LawLocalDatasource {
  HiveInterface hive;

  HiveDatabaseStorage(this.hive) {}

  @override
  Future<void> addLaws(List<LawEntity> laws) async {}

  @override
  Future<void> clear() async {}
}
