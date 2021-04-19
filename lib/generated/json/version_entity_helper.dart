import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:equatable/equatable.dart';

versionEntityFromJson(VersionEntity data, Map<String, dynamic> json) {
	if (json['detail'] != null) {
		data.detail = VersionDetailEntity().fromJson(json['detail']);
	}
	if (json['milis'] != null) {
		data.milis = json['milis'] is String
				? int.tryParse(json['milis'])
				: json['milis'].toInt();
	}
	if (json['timestamp'] != null) {
		data.timestamp = json['timestamp'].toString();
	}
	return data;
}

Map<String, dynamic> versionEntityToJson(VersionEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['detail'] = entity.detail?.toJson();
	data['milis'] = entity.milis;
	data['timestamp'] = entity.timestamp;
	return data;
}

versionDetailEntityFromJson(VersionDetailEntity data, Map<String, dynamic> json) {
	if (json['filenames'] != null) {
		data.filenames = (json['filenames'] as List).map((v) => v.toString()).toList().cast<String>();
	}
	return data;
}

Map<String, dynamic> versionDetailEntityToJson(VersionDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['filenames'] = entity.filenames;
	return data;
}