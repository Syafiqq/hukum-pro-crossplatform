import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider.dart';
import 'package:hukum_pro/di/contract/object_resolver.dart';
import 'package:objectbox/objectbox.dart';

class StoreProviderImpl implements StoreProvider {
  ObjectResolver resolver;

  StoreProviderImpl(this.resolver);

  @override
  Store get store => resolver.getStore();
}
