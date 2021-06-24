import 'package:hukum_pro/di/module/infrastructure/firebase_module.dart';
import 'package:hukum_pro/di/module/infrastructure/object_box_module.dart';
import 'package:hukum_pro/di/module/infrastructure/shared_preferences_module.dart';

class InfrastructureModule {
  static final InfrastructureModule _singleton =
      InfrastructureModule._internal();

  factory InfrastructureModule() {
    return _singleton;
  }

  InfrastructureModule._internal();

  void build() {
    FirebaseModule().build();
    SharedPreferencesModule().build();
    ObjectBoxModule().build();
  }
}
