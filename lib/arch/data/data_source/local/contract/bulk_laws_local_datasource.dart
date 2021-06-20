import 'dart:io';

import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';

abstract class BulkLawsLocalDatasource {
  Future<List<File>> getBulkLawDiskReferences(String id, List<String> names);

  Future<List<LawEntity>> decodeBulkLaw(File file);
}
