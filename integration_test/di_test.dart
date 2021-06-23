import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_menu_order_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_year_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/version_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/cache_shared_preferences.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/object_box_database_storage.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/bulk_laws_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/law_menu_order_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_cloud_database.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_cloud_storage.dart';
import 'package:hukum_pro/arch/infrastructure/app/platform_identifier.dart';
import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider.dart';
import 'package:hukum_pro/di/contract/object_resolver.dart';
import 'package:hukum_pro/di/root_injector.dart';
import 'package:hukum_pro/objectbox.g.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
    RootInjector().build();
  });

  tearDownAll(() async {});

  test('test it should parse realtime database', () async {
    KiwiContainer container = KiwiContainer();
    expect(Firebase.app(), isNotNull);
    expect(container.resolve<FirebaseApp>(), isNotNull);
    expect(container.resolve<FirebaseDatabase>(), isNotNull);
    expect(container.resolve<FirebaseStorage>(), isNotNull);
    expect(container.resolve<FirebaseCloudDatabase>(), isNotNull);
    expect(container.resolve<VersionRemoteDatasource>(), isNotNull);
    expect(container.resolve<LawMenuOrderRemoteDatasource>(), isNotNull);
    expect(container.resolve<FirebaseCloudStorage>(), isNotNull);
    expect(container.resolve<BulkLawsRemoteDatasource>(), isNotNull);
    expect(container.resolve<Future<SharedPreferences>>(), isNotNull);
    expect(container.resolve<CacheSharedPreferences>(), isNotNull);
    expect(container.resolve<VersionLocalDatasource>(), isNotNull);
    expect(container.resolve<LawMenuOrderLocalDatasource>(), isNotNull);
    expect(container.resolve<PlatformIdentifier>(), isNotNull);
    expect(container.resolve<Future<Store>>(), isNotNull);
    expect(container.resolve<ObjectResolver>(), isNotNull);
    expect(container.resolve<StoreProvider>(), isNotNull);
    expect(container.resolve<ObjectBoxDatabaseStorage>(), isNotNull);
    expect(container.resolve<LawLocalDatasource>(), isNotNull);
    expect(container.resolve<LawYearLocalDatasource>(), isNotNull);
    checkKiwi();
  });
}

void checkKiwi() {
  KiwiContainer container = KiwiContainer();
  print('checkKiwi');
  checkObject(Firebase.app());
  checkObject(container.resolve<FirebaseApp>());
  checkObject(container.resolve<FirebaseApp>());
  checkObject(container.resolve<FirebaseDatabase>());
  checkObject(container.resolve<FirebaseDatabase>());
  checkObject(container.resolve<FirebaseStorage>());
  checkObject(container.resolve<FirebaseStorage>());
  checkObject(container.resolve<FirebaseCloudDatabase>());
  checkObject(container.resolve<FirebaseCloudDatabase>());
  checkObject(container.resolve<VersionRemoteDatasource>());
  checkObject(container.resolve<VersionRemoteDatasource>());
  checkObject(container.resolve<LawMenuOrderRemoteDatasource>());
  checkObject(container.resolve<LawMenuOrderRemoteDatasource>());
  checkObject(container.resolve<FirebaseCloudStorage>());
  checkObject(container.resolve<FirebaseCloudStorage>());
  checkObject(container.resolve<BulkLawsRemoteDatasource>());
  checkObject(container.resolve<BulkLawsRemoteDatasource>());
  checkObject(container.resolve<Future<SharedPreferences>>());
  checkObject(container.resolve<Future<SharedPreferences>>());
  checkObject(container.resolve<CacheSharedPreferences>());
  checkObject(container.resolve<CacheSharedPreferences>());
  checkObject(container.resolve<VersionLocalDatasource>());
  checkObject(container.resolve<VersionLocalDatasource>());
  checkObject(container.resolve<LawMenuOrderLocalDatasource>());
  checkObject(container.resolve<LawMenuOrderLocalDatasource>());
  checkObject(container.resolve<PlatformIdentifier>());
  checkObject(container.resolve<PlatformIdentifier>());
  checkObject(container.resolve<Future<Store>>());
  checkObject(container.resolve<Future<Store>>());
  checkObject(container.resolve<ObjectResolver>());
  checkObject(container.resolve<ObjectResolver>());
  checkObject(container.resolve<StoreProvider>());
  checkObject(container.resolve<StoreProvider>());
  checkObject(container.resolve<ObjectBoxDatabaseStorage>());
  checkObject(container.resolve<ObjectBoxDatabaseStorage>());
  checkObject(container.resolve<LawLocalDatasource>());
  checkObject(container.resolve<LawLocalDatasource>());
  checkObject(container.resolve<LawYearLocalDatasource>());
  checkObject(container.resolve<LawYearLocalDatasource>());
}

void checkObject(Object x) {
  print("${x.hashCode} - $x");
}
