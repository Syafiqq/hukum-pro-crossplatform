import 'package:firebase_database/firebase_database.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:flinq/flinq.dart';

class FirebaseApi implements VersionRemoteDatasource {
  FirebaseDatabase _database;

  FirebaseApi(this._database);

  @override
  Future<VersionEntity> getVersion() async {
    var snapshot = await _database
        .reference()
        .child('versions_new/v1')
        .orderByKey()
        .limitToLast(1)
        .once();
    var versions = snapshot.value?.values as Iterable?;
    var rawVersion = versions?.firstOrNull as Map?;
    if (rawVersion == null) throw DataNotExistsException(null, null);
    try {
      VersionEntity version = VersionEntity.fromJson(rawVersion);
      return version;
    } on TypeError catch (e) {
      throw ParseFailedException(VersionEntity, null, e);
    }
  }
}
