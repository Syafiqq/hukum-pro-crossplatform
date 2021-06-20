import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
// ignore: must_be_immutable
class LawYearEntity extends Equatable {
  @Id(assignable: false)
  int id = 0;
  @Index()
  late int year;
  int count = 0;

  @override
  List<Object?> get props => [
        id,
        year,
      ];
}