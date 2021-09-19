enum LawYearListDataPresenterType {
  law,
  loadMore,
}

class LawYearListDataPresenter {
  final String id;
  final LawYearListDataPresenterType type;
  final String year;
  final String count;

  LawYearListDataPresenter(this.id, this.type, this.year, this.count);
}
