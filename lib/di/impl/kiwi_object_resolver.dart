import 'package:hukum_pro/di/contract/object_resolver.dart';
import 'package:kiwi/kiwi.dart';
import 'package:objectbox/objectbox.dart';

class KiwiObjectResolver implements ObjectResolver {
  @override
  Store getStore() => KiwiContainer().resolve<Store>();
}
