import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_cubit.dart';
import 'package:hukum_pro/di/contract/object_resolver.dart';
import 'package:kiwi/kiwi.dart';
import 'package:objectbox/objectbox.dart';

class KiwiObjectResolver implements ObjectResolver {
  @override
  Future<Store> getStore() => KiwiContainer().resolve<Future<Store>>();

  @override
  getCheckLocalVersionCubit() =>
      KiwiContainer().resolve<CheckLocalVersionCubit>();
}
