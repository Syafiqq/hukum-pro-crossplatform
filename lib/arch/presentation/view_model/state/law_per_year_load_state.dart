import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/presentation/entity/law_per_year_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/state/load_more_data_fetcher_state.dart';

import 'law_year_load_state.dart';

part 'law_per_year_load_state.freezed.dart';

@freezed
class LawPerYearListLoadState with _$LawPerYearListLoadState {
  factory LawPerYearListLoadState({
    @Default(LoadMoreDataFetcherState.initial) LoadMoreDataFetcherState state,
    @Default([]) List<LawPerYearDataPresenter> laws,
    @Default(true) bool hasMore,
  }) = _LawPerYearListLoadState;
}
