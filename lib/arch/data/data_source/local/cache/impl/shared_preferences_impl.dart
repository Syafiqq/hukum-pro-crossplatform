import 'dart:convert';

import 'package:hukum_pro/arch/data/data_source/local/cache/contract/version_cache_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesImpl implements VersionCacheDatasource {
  SharedPreferences cache;

  SharedPreferencesImpl(this.cache);

  @override
  Future<VersionEntity?> getVersion() async {
    var versionRawJson = cache.getString('version');
    if (versionRawJson == null) {
      return null;
    }
    var versionMap = jsonDecode(versionRawJson) as Map<String, dynamic>?;
    if (versionMap == null) {
      throw ParseFailedException(VersionEntity, null, null);
    }
    try {
      VersionEntity version = VersionEntity.fromJson(versionMap);
      return version;
    } on TypeError catch (e) {
      throw ParseFailedException(VersionEntity, null, e);
    }
  }
}
