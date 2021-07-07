import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/check_local_version_and_initialize_state.dart';

class SplashViewCubit extends Cubit<SplashViewUiState> {
  final CheckVersionFirstTimeUseCase _checkVersionFirstTimeUseCase;
  final ReinitializeWholeDataUseCase _reinitializeWholeDataUseCase;

  SplashViewCubit(
    this._checkVersionFirstTimeUseCase,
    this._reinitializeWholeDataUseCase,
  ) : super(SplashViewUiState.initial());

  Future<void> checkVersion() async {
    if (!(state is InitialState || state is VersionCheckFailed)) return;

    emit(SplashViewUiState.versionLoading());

    try {
      var version = await _checkVersionFirstTimeUseCase.execute();
      version.when(
        localPresent: (VersionEntity version) {
          emit(SplashViewUiState.versionPresent(version));
        },
        needInitializeVersion: (VersionEntity version) {
          emit(SplashViewUiState.versionNotExistButRemote(version));
          initializeApp(version);
        },
      );
    } on Exception catch (e) {
      print(e);
      emit(SplashViewUiState.checkVersionFailed());
    }
  }

  Future<void> initializeApp(VersionEntity version) async {
    if (!(state is VersionLocalNotPresent || state is InitializeFailed)) return;

    emit(SplashViewUiState.initializeAppLoading());

    try {
      await _reinitializeWholeDataUseCase.execute(version);
      emit(SplashViewUiState.initializeAppSuccess());
    } on Exception catch (e) {
      print(e);
      emit(SplashViewUiState.initializeAppFailed(version));
    }
  }
}
