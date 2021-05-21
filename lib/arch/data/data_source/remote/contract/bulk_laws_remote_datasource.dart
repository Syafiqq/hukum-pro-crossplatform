import 'dart:io';

abstract class BulkLawsRemoteDatasource {
  Future<void> downloadBulkLaws(String fileName, File destination);
}
