import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/cache_shared_preferences.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'library/shared_preferences_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$SharedPreferences', () {
    late FakeSharedPreferencesStore store;
    late SharedPreferences sharedPreferences;

    setUp(() async {
      store = FakeSharedPreferencesStore({});
      SharedPreferencesStorePlatform.instance = store;
      sharedPreferences = await SharedPreferences.getInstance();
    });

    group('$CacheSharedPreferences', () {
      late CacheSharedPreferences cache;

      setUp(() async {
        cache = CacheSharedPreferences(Future.value(sharedPreferences));
      });

      group('getMenusOrEmpty', () {
        test('return empty', () async {
          SharedPreferences.setMockInitialValues({});
          await sharedPreferences.reload();

          var entity = await cache.getMenusOrEmpty();

          expect(entity, isEmpty);
        });

        test('return menus', () async {
          SharedPreferences.setMockInitialValues({
            'law_status_order': '[{"id": "1"},{"id": "2"}]',
          });
          await sharedPreferences.reload();

          var entity = await cache.getMenusOrEmpty();

          expect(entity, isNotNull);
          expect(entity, isNotEmpty);
          expect(entity.length, 2);
          expect(entity, isA<List<LawMenuOrderEntity>>());
          expect(entity, <Matcher>[
            isA<LawMenuOrderEntity>()
                .having((e) => e.id, 'id', '1')
                .having((e) => e.order, 'order', isNull)
                .having((e) => e.name, 'name', isNull),
            isA<LawMenuOrderEntity>()
                .having((e) => e.id, 'id', '2')
                .having((e) => e.order, 'order', isNull)
                .having((e) => e.name, 'name', isNull)
          ]);
        });

        test('throws parse failed exception from invalid law id type',
            () async {
          SharedPreferences.setMockInitialValues({
            'law_status_order': '[{"id": 1},{"id": 2}]',
          });
          await sharedPreferences.reload();

          await expectLater(
              cache.getMenusOrEmpty(),
              throwsA(isA<ParseFailedException>().having(
                  (e) => e.internalError,
                  'internalError',
                  isA<TypeError>().having((e) => e.toString(), 'toString',
                      "type 'int' is not a subtype of type 'String' in type cast"))));
        });

        test('throws parse failed exception from invalid list', () async {
          SharedPreferences.setMockInitialValues({
            'law_status_order': '{"id": 1}',
          });
          await sharedPreferences.reload();

          await expectLater(
              cache.getMenusOrEmpty(), throwsA(isA<ParseFailedException>()));
        });

        test('throws parse failed exception from invalid list item', () async {
          SharedPreferences.setMockInitialValues({
            'law_status_order': '[[1]]',
          });
          await sharedPreferences.reload();

          await expectLater(
              cache.getMenusOrEmpty(), throwsA(isA<ParseFailedException>()));
        });
      });

      group('setMenus', () {
        test('success set', () async {
          var entityBefore = await cache.getMenusOrEmpty();
          expect(entityBefore, isEmpty);

          var entityNow = LawMenuOrderEntity('1', '1', 1);
          await cache.setMenus([entityNow]);

          var entityAfter = await cache.getMenusOrEmpty();
          expect(entityAfter, isNotEmpty);
          expect(entityAfter.first, entityNow);
          expect(entityAfter.length, 1);
          expect(entityAfter, isA<List<LawMenuOrderEntity>>());
          expect(entityAfter, <Matcher>[
            isA<LawMenuOrderEntity>()
                .having((e) => e.id, 'id', '1')
                .having((e) => e.order, 'order', 1)
                .having((e) => e.name, 'name', '1'),
          ]);
        });
      });
    });
  });
}
