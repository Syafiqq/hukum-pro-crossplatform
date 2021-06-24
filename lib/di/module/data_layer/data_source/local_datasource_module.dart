import 'package:hukum_pro/arch/data/data_source/local/contract/bulk_laws_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_menu_order_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_year_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/version_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/cache_shared_preferences.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/disk_path_provider.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/object_box_database_storage.dart';
import 'package:hukum_pro/arch/infrastructure/app/platform_identifier.dart';
import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider.dart';
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

    container
        .registerSingleton((c) => ObjectBoxDatabaseStorage(c<StoreProvider>()));
    container.registerSingleton<LawLocalDatasource>(
        (c) => c<ObjectBoxDatabaseStorage>());
    container.registerSingleton<LawYearLocalDatasource>(
        (c) => c<ObjectBoxDatabaseStorage>());

    container
        .registerSingleton((c) => DiskPathProvider(c<PlatformIdentifier>()));
    container.registerSingleton<BulkLawsLocalDatasource>(
        (c) => c<DiskPathProvider>());
  }
}
