import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_entity.dart';
import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider.dart';
import 'package:hukum_pro/objectbox.g.dart';

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
  Future<List<LawEntity>> getLawsByYear(int year) {
    final store = storeProvider.store;
    var lawBox = store.box<LawEntity>();
    Query<LawEntity> query = lawBox.query(LawEntity_.year.equals(year)).build();
    return Future.value(query.find());
  }

  @override
  Future<LawEntity?> getLawById(int id) {
    final store = storeProvider.store;
    var lawBox = store.box<LawEntity>();
    Query<LawEntity> query = lawBox.query(LawEntity_.id.equals(id)).build();
    return Future.value(query.findFirst());
  }

  @override
  Future<LawEntity?> getLawByRemoteId(String remoteId) {
    final store = storeProvider.store;
    var lawBox = store.box<LawEntity>();
    Query<LawEntity> query =
        lawBox.query(LawEntity_.remoteId.equals(remoteId)).build();
    return Future.value(query.findFirst());
  }

  @override
  Future<void> clear() async {
    final store = storeProvider.store;
    var lawBox = store.box<LawEntity>();
    lawBox.removeAll();
  }
}
