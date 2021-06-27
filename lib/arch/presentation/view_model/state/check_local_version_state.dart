import 'package:hukum_pro/arch/domain/entity/version/check_local_version_state.dart'
    as DomainCheckLocalVersionState;

enum CheckLocalVersionStatus { initial, loading, success, failure }

class CheckLocalVersionState {
  final CheckLocalVersionStatus status;
  final DomainCheckLocalVersionState.CheckLocalVersionState? state;

  CheckLocalVersionState(this.status, this.state);
}
