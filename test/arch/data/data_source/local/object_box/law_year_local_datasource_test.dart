import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_year_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_year_entity.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/object_box_database_storage.dart';
import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider.dart';
import 'package:hukum_pro/objectbox.g.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'test_env.dart';
import 'law_year_local_datasource_test.mocks.dart';

@GenerateMocks([StoreProvider])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEnv env;
  late Store store;
  late LawYearLocalDatasource datasource;
  late MockStoreProvider storeProvider;

  setUp(() {
    env = TestEnv('law-year-entity');
    store = env.store;
    storeProvider = MockStoreProvider();
    when(storeProvider.store).thenAnswer((_) => Future.value(store));
    datasource = ObjectBoxDatabaseStorage(storeProvider);
  });

  tearDown(() {
    var box = store.box<LawYearEntity>();
    box.removeAll();
    env.close();
  });

  group('$LawYearLocalDatasource', () {
    group('addLaws', () {
      test('it should store add laws', () async {
        var entities = [1, 2].map((id) => LawYearEntity()..year = id).toList();
        var box = store.box<LawYearEntity>();
        expect(box.count(), 0);

        await datasource.addLawYears(entities);

        expect(box.getAll().length, 2);
        expect(box.count(), 2);
      });
    });

    group('getLawsByYearWithPagination', () {
      test('it should get 1 laws', () async {
        var entities = [1, 2].map((id) => LawYearEntity()..year = 1).toList();

        var box = store.box<LawYearEntity>();
        box.putMany(entities);

        var laws = await datasource.getLawYearsWithPagination(1, 1);

        expect(laws.length, 1);
        expect(laws.first.year, 1);
      });

      test('it should get 2 laws', () async {
        var entities = [1, 2].map((id) => LawYearEntity()..year = 1).toList();

        var box = store.box<LawYearEntity>();
        box.putMany(entities);

        var laws = await datasource.getLawYearsWithPagination(1, 2);

        expect(laws.length, 1);
        expect(laws.first.year, 1);
      });

      test('it should get empty laws', () async {
        var entities = [1, 2].map((id) => LawYearEntity()..year = 1).toList();

        var box = store.box<LawYearEntity>();
        box.putMany(entities);

        var laws = await datasource.getLawYearsWithPagination(1, 10);

        expect(laws.length, 0);
      });
    });

    group('getLawById', () {
      test('it should get the law', () async {
        var entities = [1].map((id) => LawYearEntity()..year = id).toList();

        var box = store.box<LawYearEntity>();
        box.putMany(entities);

        var law = await datasource.getLawYearById(1);

        expect(law, isNotNull);
      });

      test('it should get null', () async {
        var entities = [1].map((id) => LawYearEntity()..year = id).toList();

        var box = store.box<LawYearEntity>();
        box.putMany(entities);

        var law = await datasource.getLawYearById(2);

        expect(law, isNull);
      });
    });

    group('getLawYearByYear', () {
      test('it should get law', () async {
        var entities = [1, 2].map((id) => LawYearEntity()..year = id).toList();

        var box = store.box<LawYearEntity>();
        box.putMany(entities);

        var law = await datasource.getLawYearByYear(1);

        expect(law, isNotNull);
      });

      test('it should get null', () async {
        var entities = [1, 2].map((id) => LawYearEntity()..year = id).toList();

        var box = store.box<LawYearEntity>();
        box.putMany(entities);

        var law = await datasource.getLawYearByYear(3);

        expect(law, isNull);
      });
    });

    group('clear', () {
      test('it should clear laws', () async {
        var entities = [1, 2].map((id) => LawYearEntity()..year = id).toList();
        var box = store.box<LawYearEntity>();
        box.putMany(entities);
        expect(box.getAll().length, 2);
        expect(box.count(), 2);

        await datasource.deleteAllLawYear();

        expect(box.getAll().length, 0);
        expect(box.count(), 0);
      });
    });
  });
}
