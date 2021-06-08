import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/object_box_law_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:objectbox/objectbox.dart';

class ObjectBoxDatabaseStorage implements LawLocalDatasource {
  late Store store;

  ObjectBoxDatabaseStorage() {}

  @override
  Future<void> addLaws(List<ObjectBoxLawEntity> laws) async {
    var lawBox = store.box<ObjectBoxLawEntity>();
    lawBox.putMany(laws);
    store.close();
  }

  @override
  Future<void> clear() async {
    var lawBox = store.box<ObjectBoxLawEntity>();
    lawBox.removeAll();
    store.close();
  }
}
