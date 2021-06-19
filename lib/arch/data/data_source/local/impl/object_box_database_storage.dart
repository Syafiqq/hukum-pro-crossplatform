import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_entity.dart';
import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider.dart';

class ObjectBoxDatabaseStorage implements LawLocalDatasource {
  StoreProvider storeProvider;

  ObjectBoxDatabaseStorage(this.storeProvider);

  @override
  Future<void> addLaws(List<LawEntity> laws) async {
    final store = storeProvider.store;
    var lawBox = store.box<LawEntity>();
    lawBox.putMany(laws);
  }

  @override
  Future<void> clear() async {
    final store = storeProvider.store;
    var lawBox = store.box<LawEntity>();
    lawBox.removeAll();
  }
}
