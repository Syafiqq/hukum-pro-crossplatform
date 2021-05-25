import 'dart:io';

import 'package:hukum_pro/arch/data/data_source/local/contract/bulk_laws_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/bulk_laws_remote_datasource.dart';
import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';

class BulkLawsRepositoryImpl implements BulkLawsRepository {
  BulkLawsRemoteDatasource remoteDatasource;
  BulkLawsLocalDatasource localDatasource;

  BulkLawsRepositoryImpl(this.remoteDatasource, this.localDatasource);

  @override
  Future<void> downloadLaw(String name, File destination) async {
    await remoteDatasource.downloadBulkLaws(name, destination);
  }

  @override
  Future<List<File>> getFileReference(String id, List<String> names) async =>
      await localDatasource.getBulkLawDiskReferences(id, names);
}
