import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

part 'check_local_version_state.freezed.dart';

@freezed
class CheckLocalVersionState with _$CheckLocalVersionState {
  const factory CheckLocalVersionState.localPresent(VersionEntity version) =
      LocalVersionPresent;
  const factory CheckLocalVersionState.needInitializeVersion(
      VersionEntity version) = LocalVersionNeedInitialize;
}
