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
    container.registerSingleton<ObjectResolver>((_) => KiwiObjectResolver.getInstance());
    container.registerSingleton<PlatformIdentifier>(
        (_) => FlutterPlatformIdentifier());
  }
}
