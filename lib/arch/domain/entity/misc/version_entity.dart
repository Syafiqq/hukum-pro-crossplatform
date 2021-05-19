import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'version_entity.g.dart';

// ignore: must_be_immutable
@JsonSerializable(anyMap: true, explicitToJson: true)
class VersionEntity extends Equatable {
  final VersionDetailEntity? detail;
  final int? milis;
  final String? timestamp;

  VersionEntity(this.detail, this.milis, this.timestamp);

  @override
  List<Object?> get props => [detail, milis, timestamp];

  factory VersionEntity.fromJson(Map json) => _$VersionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$VersionEntityToJson(this);
}

// ignore: must_be_immutable
@JsonSerializable(anyMap: true, explicitToJson: true)
class VersionDetailEntity extends Equatable {
  final List<String>? filenames;

  VersionDetailEntity(this.filenames);

  @override
  List<Object?> get props => [filenames];

  factory VersionDetailEntity.fromJson(Map json) =>
      _$VersionDetailEntityFromJson(json);

  Map<String, dynamic> toJson() => _$VersionDetailEntityToJson(this);
}
