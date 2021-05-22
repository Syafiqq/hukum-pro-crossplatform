import 'dart:io';

import 'package:hukum_pro/arch/data/data_source/local/contract/bulk_laws_local_datasource.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:path_provider/path_provider.dart';

class DiskPathProvider implements BulkLawsLocalDatasource {
  @override
  Future<List<File>> getBulkDiskReferences(
      String id, List<String> names) async {
    try {
      var directory = await getApplicationSupportDirectory();
      var path = '${directory.path}/dump/bulk-laws/$id';
      return names.map((p) => File('$path/$p')).toList();
    } on MissingPlatformDirectoryException catch (e) {
      throw DataLocationNotFoundException(e, null);
    }
  }
}
