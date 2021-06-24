import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'law_year_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class LawYearEntity extends Equatable {
  final int id;
  final int year;
  final int count;

  LawYearEntity(this.id, this.year, this.count);

  @override
  List<Object?> get props => [
        id,
        year,
      ];

  factory LawYearEntity.fromJson(Map json) => _$LawYearEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LawYearEntityToJson(this);
}
