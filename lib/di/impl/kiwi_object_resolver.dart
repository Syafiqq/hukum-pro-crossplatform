import 'package:hukum_pro/di/contract/object_resolver.dart';
import 'package:kiwi/kiwi.dart';
import 'package:objectbox/objectbox.dart';

class KiwiObjectResolver implements ObjectResolver {
  @override
  Future<Store> getStore() => KiwiContainer().resolve<Future<Store>>();
}
