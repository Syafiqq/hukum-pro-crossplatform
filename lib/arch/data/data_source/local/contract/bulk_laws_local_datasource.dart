import 'dart:io';

import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

abstract class BulkLawsDiskDatasource {
  Future<List<File>> getBulkDiskReference(List<String> names);
}
