import 'package:hukum_pro/arch/data/data_source/local/contract/version_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';

class VersionRepositoryImpl implements VersionRepository {
  VersionRemoteDatasource remoteDatasource;
  VersionLocalDatasource cacheDatasource;

  VersionRepositoryImpl(this.remoteDatasource, this.cacheDatasource);

  @override
  Future<VersionEntity> fetchFromRemote() async =>
      await remoteDatasource.getVersion();

  @override
  Future<VersionEntity?> fetchFromLocal() async =>
      await cacheDatasource.getVersion();

  @override
  Future<void> saveToLocal(VersionEntity version) async =>
      await cacheDatasource.setVersion(version);
}
