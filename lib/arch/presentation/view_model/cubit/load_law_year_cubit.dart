import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/presentation/entity/law_year_list_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_year_load_state.dart';

var _kPageSize = 20;

class LoadLawYearCubit extends Cubit<LawYearLoadState> {
  var startingStaticId = 1000;
  final LawYearRepository _lawYearRepository;
  int _page = 0;

  LoadLawYearCubit(
    this._lawYearRepository,
  ) : super(
          LawYearLoadState(
              state: LawYearLoadUiState.initial,
              lawYears: List.empty(
                growable: true,
              ),
              hasMore: true),
        );

  Future<void> resetAndLoad(String lawId) async {
    if (!(state.state == LawYearLoadUiState.initial ||
        state.state == LawYearLoadUiState.loading)) return;

    _page = 0;
    emit(
      state.copyWith(
        state: LawYearLoadUiState.reset,
        lawYears: [],
        hasMore: true,
      ),
    );
    emit(state.copyWith(state: LawYearLoadUiState.loading));

    try {
      final rawLawYears = await _lawYearRepository.get(_kPageSize, _page);
      final hasMore = rawLawYears.length == _kPageSize;
      var lawYears = _rawDataMapper(rawLawYears);
      if (hasMore) {
        lawYears.add(createLoadMore());
      }

      emit(
        state.copyWith(
          state: LawYearLoadUiState.loadSuccess,
          lawYears: [...state.lawYears, ...lawYears],
          hasMore: hasMore,
        ),
      );
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(state: LawYearLoadUiState.loadFailed));
    }
  }

  Future<void> loadMore(String lawId) async {
    if (!(state.state == LawYearLoadUiState.loadSuccess ||
        state.state == LawYearLoadUiState.loadFailed ||
        state.state == LawYearLoadUiState.loading)) return;

    emit(state.copyWith(state: LawYearLoadUiState.loadMore));

    try {
      final rawLawYears = await _lawYearRepository.get(_kPageSize, _page + 1);
      final hasMore = rawLawYears.length == _kPageSize;
      var lawYears = _rawDataMapper(rawLawYears);
      if (hasMore) {
        lawYears.add(createLoadMore());
      }

      _page += 1;
      emit(
        state.copyWith(
          state: LawYearLoadUiState.loadSuccess,
          lawYears: [...state.lawYears, ...lawYears],
          hasMore: hasMore,
        ),
      );
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(state: LawYearLoadUiState.loadFailed));
    }
  }

  List<LawYearListDataPresenter> _rawDataMapper(List<LawYearEntity> years) {
    return years
        .map(
          (year) => LawYearListDataPresenter(
            id: "${year.id}",
            type: LawYearListDataPresenterType.law,
            year: "${year.year}",
            count: "${year.count}",
          ),
        )
        .toList();
  }

  LawYearListDataPresenter createLoadMore() {
    return LawYearListDataPresenter(
      id: "${++startingStaticId}",
      type: LawYearListDataPresenterType.loadMore,
      year: "",
      count: "",
    );
  }
}
