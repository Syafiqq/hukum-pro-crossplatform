import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class LawEntity {
  late int id;
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
