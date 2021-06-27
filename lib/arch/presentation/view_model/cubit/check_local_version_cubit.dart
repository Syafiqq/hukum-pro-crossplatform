import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/check_local_version_ui_state.dart';

class CheckLocalVersionCubit extends Cubit<CheckLocalVersionUiState> {
  final CheckVersionFirstTimeUseCase _checkVersionFirstTimeUseCase;

  CheckLocalVersionCubit(this._checkVersionFirstTimeUseCase)
      : super(
            CheckLocalVersionUiState(CheckLocalVersionUiStatus.initial, null));

  Future<void> checkVersion() async {
    if (state.status == CheckLocalVersionUiStatus.loading) return;

    emit(state.copyWith(status: CheckLocalVersionUiStatus.loading));

    try {
      var version = await _checkVersionFirstTimeUseCase.execute();
      emit(state.copyWith(
          status: CheckLocalVersionUiStatus.success, state: version));
    } on Exception {
      emit(state.copyWith(status: CheckLocalVersionUiStatus.failure));
    }
  }
}
