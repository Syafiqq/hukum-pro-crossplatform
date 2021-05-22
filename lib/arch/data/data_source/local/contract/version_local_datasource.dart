import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

abstract class VersionLocalDatasource {
  Future<VersionEntity?> getVersion();

  Future<void> setVersion(VersionEntity version);
}
