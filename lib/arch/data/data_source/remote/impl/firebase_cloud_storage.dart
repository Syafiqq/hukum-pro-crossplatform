import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/bulk_laws_remote_datasource.dart';
import 'package:hukum_pro/common/exception/built_in.dart';

class FirebaseCloudStorage implements BulkLawsRemoteDatasource {
  FirebaseStorage _storage;

  FirebaseCloudStorage(this._storage);

  @override
  Future<void> downloadBulkLaws(String fileName, File destination) async {
    try {
      await _storage.ref('stream/$fileName').writeToFile(destination);
    } on FirebaseException catch (e) {
      throw DataFetchFailureException(e, null);
    } on FileSystemException catch (e) {
      throw DataFetchFailureException(e, null);
    }
  }
}
