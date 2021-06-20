import 'dart:io';

import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';

abstract class BulkLawsRepository {
  Future<List<File>> getFileReference(String id, List<String> names);

  Future<void> downloadLaw(String name, File destination);

  Future<List<LawEntity>> decodeFile(File file);
}
