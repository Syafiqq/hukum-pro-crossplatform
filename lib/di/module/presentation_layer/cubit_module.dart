import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_cubit.dart';
import 'package:kiwi/kiwi.dart';

class CubitModule {
  static final CubitModule _singleton = CubitModule._internal();

  factory CubitModule() {
    return _singleton;
  }

  CubitModule._internal();

  void build() {
    KiwiContainer container = KiwiContainer();
    container.registerFactory<CheckLocalVersionCubit>((c) =>
        CheckLocalVersionCubit(c.resolve<CheckVersionFirstTimeUseCase>()));
  }
}
