import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_year_entity.dart';

part 'law_year_load_state.freezed.dart';

@freezed
class LawYearLoadUiState with _$LawYearLoadUiState {
  const factory LawYearLoadUiState.initial() = LawYearInitialState;
  const factory LawYearLoadUiState.loading() = LawYearLoadingState;
  const factory LawYearLoadUiState.loadingMore() = LawYearLoadMoreState;
  const factory LawYearLoadUiState.loadSuccess(List<LawYearEntity> lawYears) =
      LawYearLoadSuccessState;
  const factory LawYearLoadUiState.loadFailed() = LawYearLoadFailedState;
}
