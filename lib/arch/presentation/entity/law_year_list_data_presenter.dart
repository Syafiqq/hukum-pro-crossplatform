import 'package:equatable/equatable.dart';

enum LawYearListDataPresenterType {
  law,
  loadMore,
}

class LawYearListDataPresenter extends Equatable {
  final String id;
  final LawYearListDataPresenterType type;
  final String year;
  final String count;

  const LawYearListDataPresenter({
    required this.id,
    required this.type,
    required this.year,
    required this.count
  });

  @override
  List<Object?> get props => [id, type, year, count];
}
