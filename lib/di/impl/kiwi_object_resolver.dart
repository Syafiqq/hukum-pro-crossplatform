import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_and_initialize_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_year_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/selected_law_menu_cubit.dart';
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
  SelectedLawMenuCubit getSelectedLawMenuCubit() =>
      KiwiContainer().resolve<SelectedLawMenuCubit>();

  @override
  LoadLawYearCubit getLoadLawYearCubit() =>
      KiwiContainer().resolve<LoadLawYearCubit>();
}
