import 'package:hukum_pro/di/module/data_layer/data_source/local_datasource_module.dart';
import 'package:hukum_pro/di/module/data_layer/data_source/remote_datasource_module.dart';
import 'package:hukum_pro/di/module/data_layer/repository_module.dart';

class DataLayerModule {
  static final DataLayerModule _singleton = DataLayerModule._internal();

  factory DataLayerModule() {
    return _singleton;
  }

  DataLayerModule._internal();

  void build() {
    RemoteDatasourceModule().build();
    LocalDatasourceModule().build();
    RepositoryModule().build();
  }
}
