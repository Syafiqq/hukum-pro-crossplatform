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
    container.registerFactory((c) => Store(getObjectBoxModel()));
  }
}
