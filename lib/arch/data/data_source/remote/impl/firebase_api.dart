import 'package:firebase_database/firebase_database.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';

class FirebaseApi implements VersionRemoteDatasource {
  FirebaseDatabase _database;

  FirebaseApi(this._database);

  @override
  Future<VersionEntity> getVersion() async {
    Map? snapshot = (await _database
            .reference()
            .child('versions_new/v1')
            .orderByKey()
            .limitToLast(1)
            .once())
        .value
        ?.values
        ?.first as Map?;
    if (snapshot == null) throw DataNotExistsException(null);
    try {
      VersionEntity versionEntity = VersionEntity.fromJson(snapshot);
      return versionEntity;
    } on Exception catch (e) {
      throw ParseFailedException(VersionEntity, e);
    }
  }
}
