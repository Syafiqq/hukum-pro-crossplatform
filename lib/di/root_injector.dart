import 'package:hukum_pro/di/module/core_module.dart';
import 'package:hukum_pro/di/module/data_layer/data_source/local_datasource_module.dart';
import 'package:hukum_pro/di/module/data_layer/data_source/remote_datasource_module.dart';
import 'package:hukum_pro/di/module/data_layer_module.dart';
import 'package:hukum_pro/di/module/domain_layer_module.dart';
import 'package:hukum_pro/di/module/infrastructure/firebase_module.dart';
import 'package:hukum_pro/di/module/infrastructure/shared_preferences_module.dart';
import 'package:hukum_pro/di/module/infrastructure_module.dart';
import 'package:hukum_pro/di/module/presentation_layer_module.dart';

import 'module/infrastructure/object_box_module.dart';

class RootInjector {
  static final RootInjector _singleton = RootInjector._internal();

  factory RootInjector() {
    return _singleton;
  }

  RootInjector._internal();

  void build() {
    CoreModule().build();
    InfrastructureModule().build();
    DataLayerModule().build();
    DomainLayerModule().build();
    PresentationLayerModule().build();
  }
}
