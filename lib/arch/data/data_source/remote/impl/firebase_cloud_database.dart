import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_platform_interface/firebase_database_platform_interface.dart';
import 'package:flinq/flinq.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/law_menu_order_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:hukum_pro/common/exception/defined_exception.dart';

class FirebaseCloudDatabase
    implements VersionRemoteDatasource, LawMenuOrderRemoteDatasource {
  FirebaseDatabase _database;

  FirebaseCloudDatabase(this._database);

  @override
  Future<VersionEntity> getVersion() async {
    try {
      final snapshot = await _database
          .reference()
          .child('versions_new/v1')
          .orderByKey()
          .limitToLast(1)
          .once();
      final rawVersions = snapshot.value;
      final rawVersion =
          rawVersions is Map ? rawVersions.values.firstOrNull : null;
      if (rawVersion is! Map) {
        throw ParseFailedException(Map, null, null);
      }
      try {
        VersionEntity version = VersionEntity.fromJson(rawVersion);
        return version;
      } on TypeError catch (e) {
        throw ParseFailedException(VersionEntity, null, e);
      }
    } on FirebaseException catch (e) {
      throw DataFetchFailureException(e, null);
    } on DatabaseError catch (e) {
      throw DataFetchFailureException(
          DefinedException(null, null, '00C-${e.code}', e.message), null);
    } on DatabaseErrorPlatform catch (e) {
      throw DataFetchFailureException(
          DefinedException(null, null, '00C-${e.code}', e.message), null);
    }
  }

  @override
  Future<List<LawMenuOrderEntity>> getMenus() async {
    try {
      final snapshot = await _database
          .reference()
          .child('law_status_order')
          .orderByKey()
          .once();
      final rawMenusSnapshot = snapshot.value;
      final rawMenus = rawMenusSnapshot is Map ? rawMenusSnapshot.values : null;

      if (rawMenus is! Iterable) {
        throw ParseFailedException(Iterable, null, null);
      }

      final menus = <LawMenuOrderEntity>[];

      for (dynamic rawMenu in rawMenus) {
        if (rawMenu is! Map) {
          continue;
        }
        try {
          final menu = LawMenuOrderEntity.fromJson(rawMenu);
          menus.add(menu);
        } on TypeError catch (e) {
          throw ParseFailedException(LawMenuOrderEntity, null, e);
        }
      }
      return menus;
    } on FirebaseException catch (e) {
      throw DataFetchFailureException(e, null);
    } on DatabaseError catch (e) {
      throw DataFetchFailureException(
          DefinedException(null, null, '00C-${e.code}', e.message), null);
    } on DatabaseErrorPlatform catch (e) {
      throw DataFetchFailureException(
          DefinedException(null, null, '00C-${e.code}', e.message), null);
    }
  }
}
