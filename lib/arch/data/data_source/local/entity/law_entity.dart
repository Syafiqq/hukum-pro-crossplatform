import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
// ignore: must_be_immutable
class LawEntity extends Equatable {
  @Id(assignable: false)
  int id = 0;
  @Index()
  late String remoteId;
  @Index()
  late int year;
  String? no;
  String? description;
  String? status;
  String? reference;
  @Index()
  String category = "";
  DateTime? dateCreated;

  @override
  List<Object?> get props => [
        id,
        remoteId,
      ];
}
