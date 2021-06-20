class RootInjector {
  static final RootInjector _singleton = RootInjector._internal();

  factory RootInjector() {
    return _singleton;
  }

  RootInjector._internal();

  void build() {

  }
}
