import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_cloud_database.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_cloud_storage.dart';
import 'package:kiwi/kiwi.dart';

part 'remote_datasource_module.g.dart';

class RemoteDatasourceModule {
  static final RemoteDatasourceModule _singleton =
      RemoteDatasourceModule._internal();

  factory RemoteDatasourceModule() {
    return _singleton;
  }

  RemoteDatasourceModule._internal();

  void build() {
    _$RemoteDatasourceInjectorModule().build();
  }
}

abstract class RemoteDatasourceInjectorModule {
  @Register.singleton(FirebaseCloudDatabase)
  @Register.singleton(FirebaseCloudStorage)
  void build();
}
