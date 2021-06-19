import 'dart:math';

import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_year_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_entity.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_year_entity.dart';
import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider.dart';
import 'package:hukum_pro/objectbox.g.dart';

var _safeInt = 9007199254740991;

class ObjectBoxDatabaseStorage
    implements LawLocalDatasource, LawYearLocalDatasource {
  StoreProvider storeProvider;

  ObjectBoxDatabaseStorage(this.storeProvider);

  @override
  Future<void> addLaws(List<LawEntity> laws) async {
    final store = storeProvider.store;
    var lawBox = store.box<LawEntity>();
    lawBox.putMany(laws);
  }

  @override
  Future<List<LawEntity>> getLawsByYear(int year) =>
      getLawsByYearWithPagination(year, _safeInt, 0);

  @override
  Future<List<LawEntity>> getLawsByYearWithPagination(
      int year, int limit, int page) async {
    final store = storeProvider.store;
    var lawBox = store.box<LawEntity>();
    Query<LawEntity> query = lawBox.query(LawEntity_.year.equals(year)).build()
      ..offset = (max(1, page) - 1) * limit
      ..limit = limit;
    return Future.value(query.find());
  }

  @override
  Future<LawEntity?> getLawById(int id) async {
    final store = storeProvider.store;
    var lawBox = store.box<LawEntity>();
    Query<LawEntity> query = lawBox.query(LawEntity_.id.equals(id)).build();
    return Future.value(query.findFirst());
  }

  @override
  Future<LawEntity?> getLawByRemoteId(String remoteId) async {
    final store = storeProvider.store;
    var lawBox = store.box<LawEntity>();
    Query<LawEntity> query =
        lawBox.query(LawEntity_.remoteId.equals(remoteId)).build();
    return Future.value(query.findFirst());
  }

  @override
  Future<void> deleteAllLaw() async {
    final store = storeProvider.store;
    var lawBox = store.box<LawEntity>();
    lawBox.removeAll();
  }

  @override
  Future<void> addLawYears(List<LawYearEntity> laws) async {
    final store = storeProvider.store;
    var lawBox = store.box<LawYearEntity>();
    lawBox.putMany(laws);
  }

  @override
  Future<LawYearEntity?> getLawYearById(int id) async {
    final store = storeProvider.store;
    var lawBox = store.box<LawYearEntity>();
    Query<LawYearEntity> query =
        lawBox.query(LawYearEntity_.id.equals(id)).build();
    return Future.value(query.findFirst());
  }

  @override
  Future<LawYearEntity?> getLawYearByYear(int year) async {
    final store = storeProvider.store;
    var lawBox = store.box<LawYearEntity>();
    Query<LawYearEntity> query =
        lawBox.query(LawYearEntity_.year.equals(year)).build();
    return Future.value(query.findFirst());
  }

  @override
  Future<List<LawYearEntity>> getLawYearsWithPagination(
      int limit, int page) async {
    final store = storeProvider.store;
    var lawBox = store.box<LawYearEntity>();
    Query<LawYearEntity> query = lawBox.query().build()
      ..offset = (max(1, page) - 1) * limit
      ..limit = limit;
    return Future.value(query.find());
  }

  @override
  Future<void> deleteAllLawYear() async {
    final store = storeProvider.store;
    var lawBox = store.box<LawYearEntity>();
    lawBox.removeAll();
  }
}
