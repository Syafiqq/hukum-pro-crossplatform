import 'package:hukum_pro/di/module/data_source/local_datasource_module.dart';
import 'package:hukum_pro/di/module/data_source/remote_datasource_module.dart';
import 'package:hukum_pro/di/module/infrastructure/firebase_module.dart';
import 'package:hukum_pro/di/module/infrastructure/shared_preferences_module.dart';

class RootInjector {
  static final RootInjector _singleton = RootInjector._internal();

  factory RootInjector() {
    return _singleton;
  }

  RootInjector._internal();

  void build() {
    FirebaseModule().build();
    SharedPreferencesModule().build();
    RemoteDatasourceModule().build();
    LocalDatasourceModule().build();
  }
}
