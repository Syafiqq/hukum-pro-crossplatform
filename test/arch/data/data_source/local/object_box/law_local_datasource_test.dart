import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_entity.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/object_box_database_storage.dart';
import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider.dart';
import 'package:hukum_pro/objectbox.g.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'test_env.dart';
import 'law_local_datasource_test.mocks.dart';

@GenerateMocks([StoreProvider])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEnv env;
  late Store store;
  late LawLocalDatasource datasource;
  late MockStoreProvider storeProvider;

  setUp(() {
    env = TestEnv('box');
    store = env.store;
    storeProvider = MockStoreProvider();
    when(storeProvider.store).thenReturn(store);
    datasource = ObjectBoxDatabaseStorage(storeProvider);
  });

  tearDown(() {
    env.close();
  });

  group('$LawLocalDatasource', () {
    test('it should store add laws', () async {
      var entities =
          [1, 2].map((id) => LawEntity()
            ..remoteId = id.toString()
            ..year = id
          ).toList();
      var box = store.box<LawEntity>();
      expect(box.count(), 0);

      await datasource.addLaws(entities);

      expect(box.getAll().length, 2);
      expect(box.count(), 2);
    });

    test('it should clear laws', () async {
      var entities =
          [1, 2].map((id) => LawEntity()
            ..remoteId = id.toString()
            ..year = id
          ).toList();
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
