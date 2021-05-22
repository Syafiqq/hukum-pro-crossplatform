import 'dart:convert';

import 'package:hukum_pro/arch/data/data_source/local/contract/version_local_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheSharedPreferences implements VersionLocalDatasource {
  SharedPreferences cache;

  CacheSharedPreferences(this.cache);

  @override
  Future<VersionEntity?> getVersion() async {
    var versionRawJson = cache.getString('version');
    if (versionRawJson == null) {
      return null;
    }
    Map<String, dynamic> versionMap = jsonDecode(versionRawJson);
    try {
      VersionEntity version = VersionEntity.fromJson(versionMap);
      return version;
    } on TypeError catch (e) {
      throw ParseFailedException(VersionEntity, null, e);
    }
  }

  @override
  Future<void> setVersion(VersionEntity version) async {
    var versionMap = version.toJson();
    var versionRawJson = jsonEncode(versionMap);
    await cache.setString('version', versionRawJson);
  }
}
