import 'package:hukum_pro/di/module/presentation_layer/cubit_module.dart';

class PresentationLayerModule {
  static final PresentationLayerModule _singleton =
      PresentationLayerModule._internal();

  factory PresentationLayerModule() {
    return _singleton;
  }

  PresentationLayerModule._internal();

  void build() {
    CubitModule().build();
  }
}
