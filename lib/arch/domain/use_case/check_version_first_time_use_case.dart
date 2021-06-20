import 'package:hukum_pro/arch/domain/entity/version/check_local_version_state.dart';

abstract class CheckVersionFirstTimeUseCase {
  Future<CheckLocalVersionState> execute();
}
