import 'package:hukum_pro/arch/doman/entity/misc/version_entity.dart';

abstract class VersionRemoteDatasource {
  Future<VersionEntity> getVersion();
}
