import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
// ignore: must_be_immutable
class LawYearEntity extends Equatable {
  @Id(assignable: false)
  int id = 0;
  @Index()
  int year = 0;
  int count = 0;
  @Index()
  String category = "";

  @override
  List<Object?> get props => [
        id,
        year,
      ];
}
