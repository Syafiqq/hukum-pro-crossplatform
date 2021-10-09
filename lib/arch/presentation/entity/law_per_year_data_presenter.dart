import 'package:equatable/equatable.dart';

enum LawPerYearDataPresenterType {
  law,
  loadMore,
}

class LawPerYearDataPresenter extends Equatable {
  final String id;
  final LawPerYearDataPresenterType type;
  final String name;

  const LawPerYearDataPresenter(
      {required this.id, required this.type, required this.name});

  @override
  List<Object?> get props => [id, type, name];
}
