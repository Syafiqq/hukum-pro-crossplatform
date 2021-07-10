import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_and_initialize_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
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
      ),
    );
  }
}
