// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/bulk_laws_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/version_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/bulk_laws_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/data/repository/bulk_laws_repository_impl.dart';
import 'package:hukum_pro/arch/data/repository/version_repository_impl.dart';
import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';
import 'package:mockito/annotations.dart';

import 'bulk_laws_repository_test.mocks.dart';
import 'version_repository_test.mocks.dart';

@GenerateMocks([BulkLawsRemoteDatasource, BulkLawsLocalDatasource])
void main() {
  group('$BulkLawsRepository', () {
    BulkLawsRemoteDatasource mockBulkLawsRemoteDatasource;
    BulkLawsLocalDatasource mockBulkLawsLocalDatasource;
    BulkLawsRepository repository;

    setUp(() {
      mockBulkLawsRemoteDatasource = MockBulkLawsRemoteDatasource();
      mockBulkLawsLocalDatasource = MockBulkLawsLocalDatasource();
      repository = BulkLawsRepositoryImpl(
          mockBulkLawsRemoteDatasource, mockBulkLawsLocalDatasource);
    });
  });
}
