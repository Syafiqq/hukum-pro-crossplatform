import 'package:hukum_pro/di/module/data_source/remote_datasource_module.dart';
import 'package:hukum_pro/di/module/infrastructure/firebase_module.dart';

class RootInjector {
  static final RootInjector _singleton = RootInjector._internal();

  factory RootInjector() {
    return _singleton;
  }

  RootInjector._internal();

  void build() {
    FirebaseModule().build();
    RemoteDatasourceModule().build();
  }
}
