import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';

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
    @Default([]) List<LawYearEntity> lawYears,
    @Default(true) bool hasMore,
  }) = _LawYearLoadState;
}
