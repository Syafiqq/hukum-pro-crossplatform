import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hukum_pro/arch/infrastructure/app/flutter_platform_identifier.dart';
import 'package:hukum_pro/arch/infrastructure/app/platform_identifier.dart';
import 'package:hukum_pro/di/contract/object_resolver.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';
import 'package:kiwi/kiwi.dart';

class CoreModule {
  static final CoreModule _singleton = CoreModule._internal();

  factory CoreModule() {
    return _singleton;
  }

  CoreModule._internal();

  void build() {
    KiwiContainer container = KiwiContainer();
    container.registerSingleton<ObjectResolver>((_) => KiwiObjectResolver());
    container.registerSingleton<PlatformIdentifier>(
        (_) => FlutterPlatformIdentifier());
  }
}
