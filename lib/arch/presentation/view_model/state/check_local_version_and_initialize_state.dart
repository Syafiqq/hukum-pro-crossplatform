import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

part 'check_local_version_and_initialize_state.freezed.dart';

@freezed
class CheckLocalVersionAndInitializeUiState
    with _$CheckLocalVersionAndInitializeUiState {
  const factory CheckLocalVersionAndInitializeUiState.initial() = InitialState;
  const factory CheckLocalVersionAndInitializeUiState.versionLoading() =
      VersionLoading;
  const factory CheckLocalVersionAndInitializeUiState.versionPresent(
    VersionEntity version,
  ) = VersionLocalPresent;
  const factory CheckLocalVersionAndInitializeUiState.versionNotExistButRemote(
    VersionEntity version,
  ) = VersionLocalNotPresent;
  const factory CheckLocalVersionAndInitializeUiState.checkVersionFailed() =
      VersionCheckFailed;
  const factory CheckLocalVersionAndInitializeUiState.initializeAppLoading() =
      InitializeLoading;
  const factory CheckLocalVersionAndInitializeUiState.initializeAppSuccess() =
      InitializeSuccess;
  const factory CheckLocalVersionAndInitializeUiState.initializeAppFailed(
    VersionEntity version,
  ) = InitializeFailed;
}
