import 'dart:io';

abstract class BulkLawsRepository {
  Future<List<File>> getFileReference(String id, List<String> names);

  Future<void> downloadLaw(String name, File destination);
}
