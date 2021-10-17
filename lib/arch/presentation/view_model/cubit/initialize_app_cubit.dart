import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/initialize_app_state.dart';

class InitializeAppCubit extends Cubit<InitializeAppState> {
  final CheckVersionFirstTimeUseCase _checkVersionFirstTimeUseCase;
  final ReinitializeWholeDataUseCase _reinitializeWholeDataUseCase;
  final VersionRepository _versionRepository;

  InitializeAppCubit(
    this._checkVersionFirstTimeUseCase,
    this._reinitializeWholeDataUseCase,
    this._versionRepository,
  ) : super(InitializeAppState.initial());

  Future<void> checkVersion() async {
    if (!(state is InitialState || state is VersionCheckFailed)) return;

    emit(InitializeAppState.versionLoading());

    try {
      var version = await _checkVersionFirstTimeUseCase.execute();
      version.when(
        localPresent: (VersionEntity version) {
          emit(InitializeAppState.versionPresent(version));
        },
        needInitializeVersion: (VersionEntity version) {
          emit(InitializeAppState.versionNotExistButRemote(
            version,
          ));
          initializeApp(version);
        },
      );
    } on Exception catch (e) {
      print(e);
      emit(InitializeAppState.checkVersionFailed());
    }
  }

  Future<void> initializeApp(VersionEntity version) async {
    if (!(state is VersionLocalNotPresent || state is InitializeFailed)) return;

    emit(InitializeAppState.initializeAppLoading());

    try {
      await _reinitializeWholeDataUseCase.execute(version);
      await _versionRepository.saveToLocal(version);
      emit(InitializeAppState.initializeAppSuccess());
    } on Exception catch (e) {
      print(e);
      emit(InitializeAppState.initializeAppFailed(version));
    }
  }
}
