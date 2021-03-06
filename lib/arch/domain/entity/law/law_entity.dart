import 'package:equatable/equatable.dart';
import 'package:hukum_pro/common/converter/json/string_int_to_int_type_adapter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'law_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class LawEntity extends Equatable {
  @JsonKey(name: '_id')
  final int id;
  @JsonKey(name: 'id')
  final String remoteId;
  @JsonKey(
      toJson: StringIntToIntTypeAdapter.toJson,
      fromJson: StringIntToIntTypeAdapter.fromJson)
  final int? year;
  final String? no;
  final String? description;
  final String? status;
  final String? reference;
  final String? category;
  @JsonKey(name: 'date_created')
  final DateTime? dateCreated;

  LawEntity(this.id, this.remoteId, this.year, this.no, this.description,
      this.status, this.reference, this.category, this.dateCreated);

  @override
  List<Object?> get props => [
        id,
        remoteId,
      ];

  factory LawEntity.fromJson(Map json) => _$LawEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LawEntityToJson(this);
}
