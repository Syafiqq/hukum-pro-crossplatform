import 'package:hukum_pro/arch/presentation/view_model/cubit/initialize_app_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_menu_navigation_list_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_per_year_list_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_year_list_cubit.dart';
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
  InitializeAppCubit
      getInitializeAppCubit() =>
          KiwiContainer().resolve<InitializeAppCubit>();

  @override
  LawMenuNavigationListCubit getLawMenuNavigationListCubit() =>
      KiwiContainer().resolve<LawMenuNavigationListCubit>();

  @override
  LawYearListCubit getLawYearListCubit() =>
      KiwiContainer().resolve<LawYearListCubit>();

  @override
  LawPerYearListCubit getLoadLawPerYearCubit() =>
      KiwiContainer().resolve<LawPerYearListCubit>();
}
