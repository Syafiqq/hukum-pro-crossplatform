import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatasourceModule {
  static final LocalDatasourceModule _singleton =
      LocalDatasourceModule._internal();

  factory LocalDatasourceModule() {
    return _singleton;
  }

  LocalDatasourceModule._internal();

  void build() {
    final KiwiContainer container = KiwiContainer();
    container
        .registerSingleton((c) async => await SharedPreferences.getInstance());
  }
}
