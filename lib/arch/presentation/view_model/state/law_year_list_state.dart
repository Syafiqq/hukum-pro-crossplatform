import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/presentation/entity/law_year_list_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/state/load_more_data_fetcher_state.dart';

part 'law_year_list_state.freezed.dart';

@freezed
class LawYearListState with _$LawYearListState {
  factory LawYearListState({
    @Default(LoadMoreDataFetcherState.initial) LoadMoreDataFetcherState state,
    @Default([]) List<LawYearListDataPresenter> lawYears,
    @Default(true) bool hasMore,
  }) = _LawYearListState;
}
