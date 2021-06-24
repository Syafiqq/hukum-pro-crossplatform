class PresentationLayerModule {
  static final PresentationLayerModule _singleton =
      PresentationLayerModule._internal();

  factory PresentationLayerModule() {
    return _singleton;
  }

  PresentationLayerModule._internal();

  void build() {}
}
