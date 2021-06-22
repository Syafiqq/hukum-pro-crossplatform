import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider.dart';
import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider_impl.dart';
import 'package:hukum_pro/di/contract/object_resolver.dart';
import 'package:hukum_pro/objectbox.g.dart';
import 'package:kiwi/kiwi.dart';
import 'package:objectbox/objectbox.dart';

class ObjectBoxModule {
  static final ObjectBoxModule _singleton = ObjectBoxModule._internal();

  factory ObjectBoxModule() {
    return _singleton;
  }

  ObjectBoxModule._internal();

  void build() {
    KiwiContainer container = KiwiContainer();
    container.registerFactory<Store>((c) => Store(getObjectBoxModel()));
    container.registerSingleton<StoreProvider>(
        (c) => StoreProviderImpl(c<ObjectResolver>()));
  }
}
