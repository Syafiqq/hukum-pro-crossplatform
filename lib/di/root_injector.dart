import 'package:hukum_pro/di/module/core_module.dart';
import 'package:hukum_pro/di/module/data_layer_module.dart';
import 'package:hukum_pro/di/module/domain_layer_module.dart';
import 'package:hukum_pro/di/module/infrastructure_module.dart';
import 'package:hukum_pro/di/module/presentation_layer_module.dart';

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
