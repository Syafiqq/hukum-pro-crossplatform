import 'package:hukum_pro/arch/data/data_source/local/contract/law_menu_order_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/version_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/cache_shared_preferences.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatasourceModule {
  static final LocalDatasourceModule _singleton =
      LocalDatasourceModule._internal();

  factory LocalDatasourceModule() {
    return _singleton;
  }

  LocalDatasourceModule._internal();

  void build() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton(
        (c) => CacheSharedPreferences(c<Future<SharedPreferences>>()));

    container.registerSingleton<VersionLocalDatasource>(
        (c) => c<CacheSharedPreferences>());
    container.registerSingleton<LawMenuOrderLocalDatasource>(
        (c) => c<CacheSharedPreferences>());
  }
}
