import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

part 'splash_view_ui_state.freezed.dart';

@freezed
class SplashViewUiState with _$SplashViewUiState {
  const factory SplashViewUiState.initial() = InitialState;
  const factory SplashViewUiState.versionLoading() = VersionLoading;
  const factory SplashViewUiState.versionPresent(
    VersionEntity version,
  ) = VersionPresent;
  const factory SplashViewUiState.checkVersionSuccess(
    VersionEntity version,
  ) = VersionCheckSuccess;
  const factory SplashViewUiState.checkVersionFailed(
    Exception exception,
  ) = VersionCheckFailed;
  const factory SplashViewUiState.initializeAppLoading() = InitializeLoading;
  const factory SplashViewUiState.initializeAppSuccess() = InitializeSuccess;
  const factory SplashViewUiState.initializeAppFailed(
    Exception exception,
    VersionEntity version,
  ) = InitializeFailed;
}
