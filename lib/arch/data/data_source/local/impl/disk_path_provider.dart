import 'dart:convert';
import 'dart:io';

import 'package:hukum_pro/arch/data/data_source/local/contract/bulk_laws_local_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:path_provider/path_provider.dart';

class DiskPathProvider implements BulkLawsLocalDatasource {
  @override
  Future<List<File>> getBulkLawDiskReferences(
      String id, List<String> names) async {
    try {
      var directory = await getApplicationSupportDirectory();
      var path = '${directory.path}/dump/bulk-laws/$id';
      return names.map((p) => File('$path/$p')).toList();
    } on MissingPlatformDirectoryException catch (e) {
      throw DataLocationNotFoundException(e, null);
    }
  }

  @override
  Future<List<LawEntity>> decodeBulkLaw(File file) async {
    var lawsString = await file.readAsString();
    var decodedRaw = jsonDecode(lawsString);
    var lawsMap = decodedRaw is Iterable ? decodedRaw : null;
    if (lawsMap == null) {
      throw ParseFailedException(List, null, null);
    }

    var law = <LawEntity>[];
    for (var rawMenu in List<Map>.from(lawsMap)) {
      try {
        var menu = LawEntity.fromJson(rawMenu);
        law.add(menu);
      } on TypeError catch (e) {
        throw ParseFailedException(LawEntity, null, e);
      }
    }
    return law;
  }
}
