import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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
      var snapshot = await _database
          .reference()
          .child('versions_new/v1')
          .orderByKey()
          .limitToLast(1)
          .once();
      var rawVersions = snapshot.value;
      var rawVersion =
          rawVersions is Map ? rawVersions.values.firstOrNull : null;
      if (rawVersion is! Map) {
        throw DataNotExistsException(null, null);
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
          DefinedException(null, null, "00C-${e.code}", e.message), null);
    }
  }

  @override
  Future<List<LawMenuOrderEntity>> getMenus() async {
    try {
      var snapshot = await _database
          .reference()
          .child('law_status_order')
          .orderByKey()
          .once();
      var rawMenusSnapshot = snapshot.value;
      var rawMenus = rawMenusSnapshot is Map ? rawMenusSnapshot.values : null;

      if (rawMenus is! Iterable) {
        throw DataNotExistsException(null, null);
      }

      var menus = <LawMenuOrderEntity>[];

      for (dynamic rawMenu in rawMenus) {
        if (rawMenu is! Map) {
          continue;
        }
        try {
          var menu = LawMenuOrderEntity.fromJson(rawMenu);
          menus.add(menu);
        } on TypeError catch (e) {
          throw ParseFailedException(VersionEntity, null, e);
        }
      }
      return menus;
    } on FirebaseException catch (e) {
      throw DataFetchFailureException(e, null);
    } on DatabaseError catch (e) {
      throw DataFetchFailureException(
          DefinedException(null, null, "00C-${e.code}", e.message), null);
    }
  }
}
