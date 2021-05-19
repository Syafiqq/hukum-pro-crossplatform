import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/cache/impl/shared_preferences_impl.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'shared_preferences_test.dart';

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

    group('$SharedPreferencesImpl', () {
      late SharedPreferencesImpl cache;

      setUp(() async {
        cache = SharedPreferencesImpl(sharedPreferences);
      });

      group('getVersion', () {
        test('return null', () async {
          SharedPreferences.setMockInitialValues({});
          await sharedPreferences.reload();

          var entity = await cache.getVersion();

          expect(entity, isNull);
        });

        test('return version', () async {
          SharedPreferences.setMockInitialValues({
            'version': '{"milis": 1}',
          });
          await sharedPreferences.reload();

          var entity = await cache.getVersion();

          expect(entity, isNotNull);
          expect(entity, isA<VersionEntity>());

          expect(entity?.detail, isNull);
          expect(entity?.milis, 1);
          expect(entity?.timestamp, isNull);
        });

        test('throws parse failed exception from invalid version content type',
            () async {
          SharedPreferences.setMockInitialValues({
            'version': '{"milis": "1"}',
          });
          await sharedPreferences.reload();

          expect(() async => await cache.getVersion(),
              throwsA(isInstanceOf<ParseFailedException>()));
        });
      });
    });
  });
}
