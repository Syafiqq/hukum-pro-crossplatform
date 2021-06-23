import 'dart:convert';
import 'dart:io';

import 'package:hukum_pro/arch/data/data_source/local/contract/bulk_laws_local_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/arch/infrastructure/app/platform_identifier.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:path_provider/path_provider.dart';

class DiskPathProvider implements BulkLawsLocalDatasource {
  PlatformIdentifier platformIdentifier;

  DiskPathProvider(this.platformIdentifier);

  @override
  Future<List<File>> getBulkLawDiskReferences(
      String id, List<String> names) async {
    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/dump/bulk-laws/$id';
      return names.map((p) => File('$path/$p')).toList();
    } on MissingPlatformDirectoryException catch (e) {
      throw DataLocationNotFoundException(e, null);
    }
  }

  @override
  Future<List<LawEntity>> decodeBulkLaw(File file) async {
    final lawsString = await file.readAsString();
    final lawsMap = jsonDecode(lawsString);
    if (lawsMap is! Iterable) {
      throw ParseFailedException(Iterable, null, null);
    }

    final law = <LawEntity>[];
    for (final rawMenu in lawsMap) {
      if (rawMenu is! Map) {
        throw ParseFailedException(Map, null, null);
      }
      try {
        final menu = LawEntity.fromJson(rawMenu);
        law.add(menu);
      } on TypeError catch (e) {
        throw ParseFailedException(LawEntity, null, e);
      }
    }
    return law;
  }
}
