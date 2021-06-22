import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/bulk_laws_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/law_menu_order_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_cloud_database.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_cloud_storage.dart';
import 'package:kiwi/kiwi.dart';

class RemoteDatasourceModule {
  static final RemoteDatasourceModule _singleton =
      RemoteDatasourceModule._internal();

  factory RemoteDatasourceModule() {
    return _singleton;
  }

  RemoteDatasourceModule._internal();

  void build() {
    final KiwiContainer container = KiwiContainer();
    container
        .registerSingleton((c) => FirebaseCloudDatabase(c<FirebaseDatabase>()));
    container
        .registerSingleton((c) => FirebaseCloudStorage(c<FirebaseStorage>()));

    container.registerSingleton<VersionRemoteDatasource>(
        (c) => c<FirebaseCloudDatabase>());
    container.registerSingleton<LawMenuOrderRemoteDatasource>(
        (c) => c<FirebaseCloudDatabase>());

    container.registerSingleton<BulkLawsRemoteDatasource>(
        (c) => c<FirebaseCloudStorage>());
  }
}
