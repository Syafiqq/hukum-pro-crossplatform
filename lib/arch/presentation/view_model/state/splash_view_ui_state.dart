import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

part 'splash_view_ui_state.freezed.dart';

@freezed
class SplashViewUiState with _$SplashViewUiState {
  const factory SplashViewUiState.initial() = InitialState;
  const factory SplashViewUiState.loadingCheckVersion() = LoadingCheckVersion;
  const factory SplashViewUiState.versionPresent(VersionEntity version) =
      VersionPresent;
  const factory SplashViewUiState.needInitializeApp(VersionEntity version) =
      VersionInitialize;
  const factory SplashViewUiState.checkVersionFailed(Exception exception) =
      VersionCheckFailed;
  const factory SplashViewUiState.loadingInitializeApp() = LoadingInitializeApp;
  const factory SplashViewUiState.initializeAppSuccess() = InitializeSuccess;
  const factory SplashViewUiState.initializeAppFailed(Exception exception) =
      InitializeFailed;
}
