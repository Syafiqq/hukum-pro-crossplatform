enum LawMenuOrderDataPresenterType {
  header,
  search,
  law,
  sync,
  divider
}

class LawMenuOrderDataPresenter {
  final String id;
  final LawMenuOrderDataPresenterType type;
  final String name;
  bool isSelected;

  LawMenuOrderDataPresenter(this.id, this.type, this.name, this.isSelected);
}
