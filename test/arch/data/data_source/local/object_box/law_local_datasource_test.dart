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
    var box = store.box<LawEntity>();
    box.removeAll();
    env.close();
  });

  group('$LawLocalDatasource', () {
    group('addLaws', () {
      test('it should store add laws', () async {
        var entities = [1, 2]
            .map((id) => LawEntity()
              ..remoteId = id.toString()
              ..year = id)
            .toList();
        var box = store.box<LawEntity>();
        expect(box.count(), 0);

        await datasource.addLaws(entities);

        expect(box.getAll().length, 2);
        expect(box.count(), 2);
      });
    });

    group('getLawsByYear', () {
      test('it should get some laws', () async {
        var entities = [1, 2]
            .map((id) => LawEntity()
              ..remoteId = id.toString()
              ..year = id)
            .toList();

        var box = store.box<LawEntity>();
        box.putMany(entities);

        var laws = await datasource.getLawsByYear(1);

        expect(laws.length, 1);
      });

      test('it should get empty laws', () async {
        var entities = [1, 2]
            .map((id) => LawEntity()
              ..remoteId = id.toString()
              ..year = id)
            .toList();

        var box = store.box<LawEntity>();
        box.putMany(entities);

        var laws = await datasource.getLawsByYear(3);

        expect(laws.length, 0);
      });
    });

    group('getLawsByYearWithPagination', () {
      test('it should get 1 laws', () async {
        var entities = [1, 2]
            .map((id) => LawEntity()
              ..remoteId = id.toString()
              ..year = 1)
            .toList();

        var box = store.box<LawEntity>();
        box.putMany(entities);

        var laws = await datasource.getLawsByYearWithPagination(1, 1, 1);

        expect(laws.length, 1);
        expect(laws.first.id, 1);
      });

      test('it should get 2 laws', () async {
        var entities = [1, 2]
            .map((id) => LawEntity()
              ..remoteId = id.toString()
              ..year = 1)
            .toList();

        var box = store.box<LawEntity>();
        box.putMany(entities);

        var laws = await datasource.getLawsByYearWithPagination(1, 1, 2);

        expect(laws.length, 1);
        expect(laws.first.id, 2);
      });

      test('it should get empty laws', () async {
        var entities = [1, 2]
            .map((id) => LawEntity()
              ..remoteId = id.toString()
              ..year = 1)
            .toList();

        var box = store.box<LawEntity>();
        box.putMany(entities);

        var laws = await datasource.getLawsByYearWithPagination(1, 1, 10);

        expect(laws.length, 0);
      });
    });

    group('getLawById', () {
      test('it should get the law', () async {
        var entities = [1]
            .map((id) => LawEntity()
              ..remoteId = id.toString()
              ..year = id)
            .toList();

        var box = store.box<LawEntity>();
        box.putMany(entities);

        var law = await datasource.getLawById(1);

        expect(law, isNotNull);
      });

      test('it should get null', () async {
        var entities = [1]
            .map((id) => LawEntity()
              ..remoteId = id.toString()
              ..year = id)
            .toList();

        var box = store.box<LawEntity>();
        box.putMany(entities);

        var law = await datasource.getLawById(2);

        expect(law, isNull);
      });
    });

    group('getLawByRemoteId', () {
      test('it should get the law', () async {
        var entities = [1]
            .map((id) => LawEntity()
              ..remoteId = id.toString()
              ..year = id)
            .toList();

        var box = store.box<LawEntity>();
        box.putMany(entities);

        var law = await datasource.getLawByRemoteId('1');

        expect(law, isNotNull);
      });

      test('it should get null', () async {
        var entities = [1]
            .map((id) => LawEntity()
              ..remoteId = id.toString()
              ..year = id)
            .toList();

        var box = store.box<LawEntity>();
        box.putMany(entities);

        var law = await datasource.getLawByRemoteId('2');

        expect(law, isNull);
      });
    });

    group('clear', () {
      test('it should clear laws', () async {
        var entities = [1, 2]
            .map((id) => LawEntity()
              ..remoteId = id.toString()
              ..year = id)
            .toList();
        var box = store.box<LawEntity>();
        box.putMany(entities);
        expect(box.getAll().length, 2);
        expect(box.count(), 2);

        await datasource.deleteAllLaw();

        expect(box.getAll().length, 0);
        expect(box.count(), 0);
      });
    });
  });
}
