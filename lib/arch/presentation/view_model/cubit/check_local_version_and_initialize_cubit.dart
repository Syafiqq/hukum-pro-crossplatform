import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/check_local_version_and_initialize_state.dart';

class CheckLocalVersionAndInitializeCubit
    extends Cubit<CheckLocalVersionAndInitializeUiState> {
  final CheckVersionFirstTimeUseCase _checkVersionFirstTimeUseCase;
  final ReinitializeWholeDataUseCase _reinitializeWholeDataUseCase;
  final VersionRepository _versionRepository;

  CheckLocalVersionAndInitializeCubit(
    this._checkVersionFirstTimeUseCase,
    this._reinitializeWholeDataUseCase,
    this._versionRepository,
  ) : super(CheckLocalVersionAndInitializeUiState.initial());

  Future<void> checkVersion() async {
    if (!(state is InitialState || state is VersionCheckFailed)) return;

    emit(CheckLocalVersionAndInitializeUiState.versionLoading());

    try {
      var version = await _checkVersionFirstTimeUseCase.execute();
      version.when(
        localPresent: (VersionEntity version) {
          emit(CheckLocalVersionAndInitializeUiState.versionPresent(version));
        },
        needInitializeVersion: (VersionEntity version) {
          emit(CheckLocalVersionAndInitializeUiState.versionNotExistButRemote(
            version,
          ));
          initializeApp(version);
        },
      );
    } on Exception catch (e) {
      print(e);
      emit(CheckLocalVersionAndInitializeUiState.checkVersionFailed());
    }
  }

  Future<void> initializeApp(VersionEntity version) async {
    if (!(state is VersionLocalNotPresent || state is InitializeFailed)) return;

    emit(CheckLocalVersionAndInitializeUiState.initializeAppLoading());

    try {
      await _reinitializeWholeDataUseCase.execute(version);
      await _versionRepository.saveToLocal(version);
      emit(CheckLocalVersionAndInitializeUiState.initializeAppSuccess());
    } on Exception catch (e) {
      print(e);
      emit(CheckLocalVersionAndInitializeUiState.initializeAppFailed(version));
    }
  }
}
