import 'package:hukum_pro/arch/data/data_source/local/contract/bulk_laws_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_menu_order_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_year_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/version_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/bulk_laws_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/law_menu_order_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/data/repository/bulk_laws_repository_impl.dart';
import 'package:hukum_pro/arch/data/repository/law_menu_order_repository_impl.dart';
import 'package:hukum_pro/arch/data/repository/law_repository_impl.dart';
import 'package:hukum_pro/arch/data/repository/law_year_repository_impl.dart';
import 'package:hukum_pro/arch/data/repository/version_repository_impl.dart';
import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:kiwi/kiwi.dart';

class RepositoryModule {
  static final RepositoryModule _singleton = RepositoryModule._internal();

  factory RepositoryModule() {
    return _singleton;
  }

  RepositoryModule._internal();

  void build() {
    final KiwiContainer container = KiwiContainer();

    container.registerSingleton<BulkLawsRepository>((c) =>
        BulkLawsRepositoryImpl(
            c<BulkLawsRemoteDatasource>(), c<BulkLawsLocalDatasource>()));

    container.registerSingleton<LawMenuOrderRepository>((c) =>
        LawMenuOrderRepositoryImpl(c<LawMenuOrderRemoteDatasource>(),
            c<LawMenuOrderLocalDatasource>()));

    container.registerSingleton<LawRepository>(
        (c) => LawRepositoryImpl(c<LawLocalDatasource>()));

    container.registerSingleton<LawYearRepository>(
        (c) => LawYearRepositoryImpl(c<LawYearLocalDatasource>()));

    container.registerSingleton<VersionRepository>((c) => VersionRepositoryImpl(
        c<VersionRemoteDatasource>(), c<VersionLocalDatasource>()));
  }
}
