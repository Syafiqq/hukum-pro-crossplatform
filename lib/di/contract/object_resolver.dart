import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_and_initialize_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_per_year_list_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/law_year_list_cubit.dart';
import 'package:objectbox/objectbox.dart';

abstract class ObjectResolver {
  Future<Store> getStore();

  CheckLocalVersionAndInitializeCubit getCheckLocalVersionAndInitializeCubit();
  LoadLawMenuCubit getLoadLawMenuCubit();
  LawYearListCubit getLawYearListCubit();
  LawPerYearListCubit getLoadLawPerYearCubit();
}
