import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flinq/flinq.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';

class FirebaseCloudDatabase implements VersionRemoteDatasource {
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
      var versions = snapshot.value?.values as Iterable?;
      var rawVersion = versions?.firstOrNull as Map?;
      if (rawVersion == null) throw DataNotExistsException(null, null);
      try {
        VersionEntity version = VersionEntity.fromJson(rawVersion);
        return version;
      } on TypeError catch (e) {
        throw ParseFailedException(VersionEntity, null, e);
      }
    } on FirebaseException catch (e) {
      throw DataFetchFailureException(e, null);
    }
  }
}
