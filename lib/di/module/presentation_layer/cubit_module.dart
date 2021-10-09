import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/domain/service/active_law_service.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_and_initialize_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_year_page_title_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_per_year_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_year_cubit.dart';
import 'package:kiwi/kiwi.dart';

class CubitModule {
  static final CubitModule _singleton = CubitModule._internal();

  factory CubitModule() {
    return _singleton;
  }

  CubitModule._internal();

  void build() {
    KiwiContainer container = KiwiContainer();
    container.registerFactory<CheckLocalVersionAndInitializeCubit>(
      (c) => CheckLocalVersionAndInitializeCubit(
        c.resolve<CheckVersionFirstTimeUseCase>(),
        c.resolve<ReinitializeWholeDataUseCase>(),
      ),
    );
    container.registerFactory<LoadLawMenuCubit>(
      (c) => LoadLawMenuCubit(
        c.resolve<LawMenuOrderRepository>(),
        c.resolve<ActiveLawService>(),
      ),
    );
    container.registerFactory<LoadLawYearCubit>(
      (c) => LoadLawYearCubit(
        c.resolve<LawYearRepository>(),
        c.resolve<ActiveLawService>(),
      ),
    );
    container.registerFactory<LoadLawPerYearCubit>(
      (c) => LoadLawPerYearCubit(
        c.resolve<LawRepository>(),
        c.resolve<ActiveLawService>(),
      ),
    );
    container.registerFactory<LawYearPageTitleCubit>(
      (c) => LawYearPageTitleCubit(
        c.resolve<ActiveLawService>(),
      ),
    );
  }
}
