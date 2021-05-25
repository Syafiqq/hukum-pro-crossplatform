import 'dart:io';

abstract class BulkLawsLocalDatasource {
  Future<List<File>> getBulkLawDiskReferences(String id, List<String> names);
}
