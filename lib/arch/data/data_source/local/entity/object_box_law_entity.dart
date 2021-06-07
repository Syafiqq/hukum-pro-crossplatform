import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import 'law_entity.dart';

@Entity()
// ignore: must_be_immutable
class ObjectBoxLawEntity extends Equatable implements LawEntity {
  @Id(assignable: false)
  late int id;
  @Index()
  late String remoteId;
  int? year;
  String? no;
  String? description;
  String? status;
  String? reference;
  String? category;
  DateTime? dateCreated;

  @override
  List<Object?> get props => [
        id,
        remoteId,
        year,
        no,
        description,
        status,
        reference,
        category,
        dateCreated
      ];
}
