import 'package:hukum_pro/arch/domain/entity/version/check_local_version_state.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';

class CheckVersionFirstTimeUseCaseImpl implements CheckVersionFirstTimeUseCase {
  VersionRepository versionRepository;

  CheckVersionFirstTimeUseCaseImpl(this.versionRepository);

  @override
  Future<CheckLocalVersionState> execute() async {
    final localVersion = await versionRepository.fetchFromLocal();
    if (localVersion != null) {
      return CheckLocalVersionState.localPresent(localVersion);
    }
    final remoteVersion = await versionRepository.fetchFromRemote();
    return CheckLocalVersionState.needInitializeVersion(remoteVersion);
  }
}
