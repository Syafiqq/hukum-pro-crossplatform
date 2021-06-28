import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_cubit.dart';
import 'package:objectbox/objectbox.dart';

abstract class ObjectResolver {
  Future<Store> getStore();

  CheckLocalVersionCubit getCheckLocalVersionCubit();
}
