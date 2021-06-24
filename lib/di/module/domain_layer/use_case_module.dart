import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case_impl.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case_impl.dart';
import 'package:kiwi/kiwi.dart';

class UseCaseModule {
  static final UseCaseModule _singleton = UseCaseModule._internal();

  factory UseCaseModule() {
    return _singleton;
  }

  UseCaseModule._internal();

  void build() {
    final KiwiContainer container = KiwiContainer();

    container.registerSingleton<CheckVersionFirstTimeUseCase>(
        (c) => CheckVersionFirstTimeUseCaseImpl(c<VersionRepository>()));

    container.registerSingleton<ReinitializeWholeDataUseCase>(
        (c) => ReinitializeWholeDataUseCaseImpl(
              c<BulkLawsRepository>(),
              c<LawRepository>(),
              c<LawYearRepository>(),
              c<LawMenuOrderRepository>(),
            ));
  }
}
