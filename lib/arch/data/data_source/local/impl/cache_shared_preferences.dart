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
    var versionMap = jsonDecode(versionRawJson);
    if (versionMap is! Map) {
      throw ParseFailedException(Map, null, null);
    }

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
  Future<List<LawMenuOrderEntity>> getMenusOrEmpty() async {
    var menusRawJson = cache.getString('law_status_order');
    if (menusRawJson == null) {
      return <LawMenuOrderEntity>[];
    }
    var menusList = jsonDecode(menusRawJson);
    if (menusList is! Iterable) {
      throw ParseFailedException(Iterable, null, null);
    }

    var menus = <LawMenuOrderEntity>[];
    for (var rawMenu in menusList) {
      if (rawMenu is! Map) {
        throw ParseFailedException(Map, null, null);
      }
      try {
        var menu = LawMenuOrderEntity.fromJson(rawMenu);
        menus.add(menu);
      } on TypeError catch (e) {
        throw ParseFailedException(LawMenuOrderEntity, null, e);
      }
    }
    return menus;
  }

  @override
  Future<void> setMenus(List<LawMenuOrderEntity> menus) async {
    var menusMap = menus.map((menu) => menu.toJson()).toList(growable: false);
    var menusRawJson = jsonEncode(menusMap);
    await cache.setString('law_status_order', menusRawJson);
  }
}
