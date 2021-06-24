import 'package:hukum_pro/di/module/domain_layer/use_case_module.dart';

class DomainLayerModule {
  static final DomainLayerModule _singleton = DomainLayerModule._internal();

  factory DomainLayerModule() {
    return _singleton;
  }

  DomainLayerModule._internal();

  void build() {
    UseCaseModule().build();
  }
}
