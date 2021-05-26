import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';

class HiveDatabaseStorage implements LawLocalDatasource {
  @override
  Future<void> addLaws(List<LawEntity> laws) {
    // TODO: implement addLaws
    throw UnimplementedError();
  }

  @override
  Future<void> clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }
}
