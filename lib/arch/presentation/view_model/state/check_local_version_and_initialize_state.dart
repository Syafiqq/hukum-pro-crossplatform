import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

part 'check_local_version_and_initialize_state.freezed.dart';

@freezed
class SplashViewUiState with _$SplashViewUiState {
  const factory SplashViewUiState.initial() = InitialState;
  const factory SplashViewUiState.versionLoading() = VersionLoading;
  const factory SplashViewUiState.versionPresent(
    VersionEntity version,
  ) = VersionLocalPresent;
  const factory SplashViewUiState.versionNotExistButRemote(
    VersionEntity version,
  ) = VersionLocalNotPresent;
  const factory SplashViewUiState.checkVersionFailed() = VersionCheckFailed;
  const factory SplashViewUiState.initializeAppLoading() = InitializeLoading;
  const factory SplashViewUiState.initializeAppSuccess() = InitializeSuccess;
  const factory SplashViewUiState.initializeAppFailed(
    VersionEntity version,
  ) = InitializeFailed;
}
