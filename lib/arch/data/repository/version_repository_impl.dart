import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';

class VersionRepositoryImpl extends VersionRepository {
  VersionRemoteDatasource remoteDatasource;

  VersionRepositoryImpl(this.remoteDatasource)

  @override
  Future<VersionEntity?> fetchFromRemote() async {
    await remoteDatasource.getVersion();
  }
}
