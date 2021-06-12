import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_entity.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/object_box_database_storage.dart';
import 'package:hukum_pro/objectbox.g.dart';

import 'test_env.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEnv env;
  late Store store;
  late LawLocalDatasource datasource;

  setUp(() {
    env = TestEnv('box');
    store = env.store;
    datasource = ObjectBoxDatabaseStorage();
    datasource.store = store;
  });

  tearDown(() {
    env.close();
  });

  group('$LawLocalDatasource', () {
    test('it should store add laws', () async {
      var entities =
          [1, 2].map((id) => LawEntity()..remoteId = id.toString()).toList();

      await datasource.addLaws(entities);

      var box = store.box<LawEntity>();
      expect(box.getAll().length, 2);
      expect(box.count(), 2);
    });

    test('it should clear laws', () async {
      var entities =
          [1, 2].map((id) => LawEntity()..remoteId = id.toString()).toList();
      var box = store.box<LawEntity>();
      box.putMany(entities);
      expect(box.getAll().length, 2);
      expect(box.count(), 2);

      await datasource.clear();

      expect(box.getAll().length, 0);
      expect(box.count(), 0);
    });
  });
}
