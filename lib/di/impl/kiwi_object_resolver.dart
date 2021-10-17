import 'package:hukum_pro/arch/domain/service/active_law_service.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_and_initialize_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_per_year_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_year_cubit.dart';
import 'package:hukum_pro/di/contract/object_resolver.dart';
import 'package:kiwi/kiwi.dart';
import 'package:objectbox/objectbox.dart';

class KiwiObjectResolver implements ObjectResolver {
  static final KiwiObjectResolver _singleton = KiwiObjectResolver._internal();

  static ObjectResolver getInstance() => _singleton;

  KiwiObjectResolver._internal();

  @override
  Future<Store> getStore() => KiwiContainer().resolve<Future<Store>>();

  @override
  CheckLocalVersionAndInitializeCubit
      getCheckLocalVersionAndInitializeCubit() =>
          KiwiContainer().resolve<CheckLocalVersionAndInitializeCubit>();

  @override
  LoadLawMenuCubit getLoadLawMenuCubit() =>
      KiwiContainer().resolve<LoadLawMenuCubit>();

  @override
  LoadLawYearCubit getLoadLawYearCubit() =>
      KiwiContainer().resolve<LoadLawYearCubit>();

  @override
  LoadLawPerYearCubit getLoadLawPerYearCubit() =>
      KiwiContainer().resolve<LoadLawPerYearCubit>();

  @override
  ActiveLawService getActiveLawService() =>
      KiwiContainer().resolve<ActiveLawService>();
}
