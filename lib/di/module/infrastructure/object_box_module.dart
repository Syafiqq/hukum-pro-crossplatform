import 'package:hukum_pro/arch/infrastructure/app/platform_identifier.dart';
import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider.dart';
import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider_impl.dart';
import 'package:hukum_pro/di/contract/object_resolver.dart';
import 'package:hukum_pro/objectbox.g.dart';
import 'package:kiwi/kiwi.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBoxModule {
  static final ObjectBoxModule _singleton = ObjectBoxModule._internal();

  factory ObjectBoxModule() {
    return _singleton;
  }

  ObjectBoxModule._internal();

  void build() {
    KiwiContainer container = KiwiContainer();
    container.registerFactory<Future<Store>>((c) async {
      final platform = c<PlatformIdentifier>();
      var path = '';
      if (platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        if (directory == null) {
          throw UnsupportedError('Platform is not supported');
        }
        path = '${directory.path}/db/';
      } else if (platform.isIOS) {
        final directory = await getApplicationSupportDirectory();
        path = '${directory.path}/db/';
      } else {
        throw UnsupportedError('Platform is not supported');
      }

      return Store(getObjectBoxModel(), directory: path);
    });
    container.registerSingleton<StoreProvider>(
        (c) => StoreProviderImpl(c<ObjectResolver>()));
  }
}
