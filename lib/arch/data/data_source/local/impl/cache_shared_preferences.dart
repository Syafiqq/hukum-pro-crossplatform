import 'dart:convert';

import 'package:hukum_pro/arch/data/data_source/local/contract/law_menu_order_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/version_local_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheSharedPreferences
    implements VersionLocalDatasource, LawMenuOrderLocalDatasource {
  Future<SharedPreferences> cache;

  CacheSharedPreferences(this.cache);

  @override
  Future<VersionEntity?> getVersion() async {
    final cache = await this.cache;
    final versionRawJson = cache.getString('version');
    if (versionRawJson == null) {
      return null;
    }
    final versionMap = jsonDecode(versionRawJson);
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
    final cache = await this.cache;
    final versionMap = version.toJson();
    final versionRawJson = jsonEncode(versionMap);
    await cache.setString('version', versionRawJson);
  }

  @override
  Future<List<LawMenuOrderEntity>> getMenusOrEmpty() async {
    final cache = await this.cache;
    final menusRawJson = cache.getString('law_status_order');
    if (menusRawJson == null) {
      return <LawMenuOrderEntity>[];
    }
    final menusList = jsonDecode(menusRawJson);
    if (menusList is! Iterable) {
      throw ParseFailedException(Iterable, null, null);
    }

    final menus = <LawMenuOrderEntity>[];
    for (final rawMenu in menusList) {
      if (rawMenu is! Map) {
        throw ParseFailedException(Map, null, null);
      }
      try {
        final menu = LawMenuOrderEntity.fromJson(rawMenu);
        menus.add(menu);
      } on TypeError catch (e) {
        throw ParseFailedException(LawMenuOrderEntity, null, e);
      }
    }
    return menus;
  }

  @override
  Future<void> setMenus(List<LawMenuOrderEntity> menus) async {
    final cache = await this.cache;
    final menusMap = menus.map((menu) => menu.toJson()).toList(growable: false);
    final menusRawJson = jsonEncode(menusMap);
    await cache.setString('law_status_order', menusRawJson);
  }
}
