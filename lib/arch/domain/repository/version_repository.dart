import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

abstract class VersionRepository {
  Future<VersionEntity?> fetchFromRemote();
}
