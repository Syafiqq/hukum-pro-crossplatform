import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/presentation/entity/law_year_list_data_presenter.dart';

part 'law_year_load_state.freezed.dart';

enum LawYearLoadUiState {
  initial,
  reset,
  loading,
  loadMore,
  loadSuccess,
  loadFailed,
}

@freezed
class LawYearLoadState with _$LawYearLoadState {
  factory LawYearLoadState({
    @Default(LawYearLoadUiState.initial) LawYearLoadUiState state,
    @Default([]) List<LawYearListDataPresenter> lawYears,
    @Default(true) bool hasMore,
  }) = _LawYearLoadState;
}
