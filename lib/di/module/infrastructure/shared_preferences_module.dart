import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesModule {
  static final SharedPreferencesModule _singleton =
      SharedPreferencesModule._internal();

  factory SharedPreferencesModule() {
    return _singleton;
  }

  SharedPreferencesModule._internal();

  void build() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((_) => SharedPreferences.getInstance());
  }
}
