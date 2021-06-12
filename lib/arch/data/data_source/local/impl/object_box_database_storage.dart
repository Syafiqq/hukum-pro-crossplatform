import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_entity.dart';
import 'package:objectbox/objectbox.dart';

class ObjectBoxDatabaseStorage implements LawLocalDatasource {
  late Store store;

  ObjectBoxDatabaseStorage();

  @override
  Future<void> addLaws(List<LawEntity> laws) async {
    var lawBox = store.box<LawEntity>();
    lawBox.putMany(laws);
  }

  @override
  Future<void> clear() async {
    var lawBox = store.box<LawEntity>();
    lawBox.removeAll();
  }
}
