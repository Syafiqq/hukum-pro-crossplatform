class DomainLayerModule {
  static final DomainLayerModule _singleton = DomainLayerModule._internal();

  factory DomainLayerModule() {
    return _singleton;
  }

  DomainLayerModule._internal();

  void build() {}
}
