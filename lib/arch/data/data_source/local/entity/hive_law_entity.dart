import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'hive_law_entity.g.dart';

@HiveType(typeId: 1)
// ignore: must_be_immutable
class HiveLawEntity extends Equatable {
  @HiveField(0)
  late int id;
  @HiveField(1)
  late String remoteId;
  @HiveField(2)
  int? year;
  @HiveField(3)
  String? no;
  @HiveField(4)
  String? description;
  @HiveField(5)
  String? status;
  @HiveField(6)
  String? reference;
  @HiveField(7)
  String? category;
  @HiveField(8)
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
