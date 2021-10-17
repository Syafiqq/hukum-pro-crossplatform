import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_and_initialize_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_menu_navigation_list_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_per_year_list_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_year_list_cubit.dart';
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
        c.resolve<VersionRepository>(),
      ),
    );
    container.registerFactory<LawMenuNavigationListCubit>(
      (c) => LawMenuNavigationListCubit(
        c.resolve<LawMenuOrderRepository>(),
      ),
    );
    container.registerFactory<LawYearListCubit>(
      (c) => LawYearListCubit(
        c.resolve<LawYearRepository>(),
      ),
    );
    container.registerFactory<LawPerYearListCubit>(
      (c) => LawPerYearListCubit(
        c.resolve<LawRepository>(),
        c.resolve<LawMenuOrderRepository>(),
      ),
    );
  }
}
