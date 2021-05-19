// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionEntity _$VersionEntityFromJson(Map json) {
  return VersionEntity(
    json['detail'] == null
        ? null
        : VersionDetailEntity.fromJson(json['detail'] as Map),
    json['milis'] as int?,
    json['timestamp'] as String?,
  );
}

Map<String, dynamic> _$VersionEntityToJson(VersionEntity instance) =>
    <String, dynamic>{
      'detail': instance.detail?.toJson(),
      'milis': instance.milis,
      'timestamp': instance.timestamp,
    };

VersionDetailEntity _$VersionDetailEntityFromJson(Map json) {
  return VersionDetailEntity(
    (json['filenames'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$VersionDetailEntityToJson(
        VersionDetailEntity instance) =>
    <String, dynamic>{
      'filenames': instance.filenames,
    };
