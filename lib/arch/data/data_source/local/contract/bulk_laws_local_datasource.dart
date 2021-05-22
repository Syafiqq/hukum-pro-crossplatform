import 'dart:io';

abstract class BulkLawsLocalDatasource {
  Future<List<File>> getBulkDiskReferences(String id, List<String> names);
}
