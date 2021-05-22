import 'dart:convert';

import 'package:hukum_pro/arch/data/data_source/local/contract/law_menu_order_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/version_local_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheSharedPreferences
    implements VersionLocalDatasource, LawMenuOrderLocalDatasource {
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

  @override
  Future<List<LawMenuOrderEntity>> getMenus() async {
    var menusRawJson = cache.getString('law_status_order');
    if (menusRawJson == null) {
      return <LawMenuOrderEntity>[];
    }
    List<dynamic> menusMap = jsonDecode(menusRawJson);
    var menus = <LawMenuOrderEntity>[];

    for (dynamic rawMenu in menusMap) {
      var rawMapMenu = rawMenu as Map?;
      if (rawMapMenu == null) {
        continue;
      }
      try {
        var menu = LawMenuOrderEntity.fromJson(rawMapMenu);
        menus.add(menu);
      } on TypeError catch (e) {
        throw ParseFailedException(VersionEntity, null, e);
      }
    }
    return menus;
  }

  @override
  Future<void> setMenus(List<LawMenuOrderEntity> menus) async {
    var menusMap = menus.map((menu) => menu.toJson());
    var menusRawJson = jsonEncode(menusMap);
    await cache.setString('law_status_order', menusRawJson);
  }
}
