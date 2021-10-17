import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

part 'initialize_app_state.freezed.dart';

@freezed
class InitializeAppState with _$InitializeAppState {
  const factory InitializeAppState.initial() = InitialState;
  const factory InitializeAppState.versionLoading() = VersionLoading;
  const factory InitializeAppState.versionPresent(
    VersionEntity version,
  ) = VersionLocalPresent;
  const factory InitializeAppState.versionNotExistButRemote(
    VersionEntity version,
  ) = VersionLocalNotPresent;
  const factory InitializeAppState.checkVersionFailed() = VersionCheckFailed;
  const factory InitializeAppState.initializeAppLoading() = InitializeLoading;
  const factory InitializeAppState.initializeAppSuccess() = InitializeSuccess;
  const factory InitializeAppState.initializeAppFailed(
    VersionEntity version,
  ) = InitializeFailed;
}
