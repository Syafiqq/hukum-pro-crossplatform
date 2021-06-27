import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/domain/entity/version/check_local_version_state.dart';

part 'check_local_version_ui_state.freezed.dart';

enum CheckLocalVersionStatus { initial, loading, success, failure }

@freezed
class CheckLocalVersionUiState with _$CheckLocalVersionUiState {
  factory CheckLocalVersionUiState(
          CheckLocalVersionStatus status, CheckLocalVersionState? state) =
      _CheckLocalVersionUiState;
}
