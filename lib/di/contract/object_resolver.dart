import 'package:hukum_pro/arch/presentation/view_model/cubit/initialize_app_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_menu_navigation_list_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_per_year_list_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_year_list_cubit.dart';
import 'package:objectbox/objectbox.dart';

abstract class ObjectResolver {
  Future<Store> getStore();

  InitializeAppCubit getInitializeAppCubit();
  LawMenuNavigationListCubit getLawMenuNavigationListCubit();
  LawYearListCubit getLawYearListCubit();
  LawPerYearListCubit getLoadLawPerYearCubit();
}
