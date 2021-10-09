import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/domain/service/active_law_service.dart';
import 'package:hukum_pro/arch/presentation/entity/law_year_list_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_year_load_state.dart';

var _kPageSize = 20;

class LoadLawYearCubit extends Cubit<LawYearLoadState> {
  final LawYearRepository _lawYearRepository;
  final ActiveLawService _activeLawService;

  var startingStaticId = 1000;
  int _page = 0;
  String _lawId = "";

  LoadLawYearCubit(
    this._lawYearRepository,
    this._activeLawService,
  ) : super(
          LawYearLoadState(
            state: LawYearLoadUiState.initial,
            lawYears: List.empty(
              growable: true,
            ),
            hasMore: true,
          ),
        );

  Future<void> resetAndLoad() async {
    if (![
      LawYearLoadUiState.initial,
      LawYearLoadUiState.loadSuccess,
      LawYearLoadUiState.loadFailed,
      LawYearLoadUiState.reset,
    ].contains(state.state)) {
      return;
    }

    final lawId = _activeLawService.getActiveLawId();
    if (lawId == null) {
      return;
    }

    _page = 0;
    _lawId = lawId;
    emit(
      state.copyWith(
        state: LawYearLoadUiState.reset,
        lawYears: [],
        hasMore: true,
      ),
    );
    emit(state.copyWith(state: LawYearLoadUiState.loading));

    try {
      final rawLawYears =
          await _lawYearRepository.get(_lawId, _kPageSize, _page);
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

  Future<void> loadMore() async {
    if (!(state.state == LawYearLoadUiState.loadSuccess ||
        state.state == LawYearLoadUiState.loadFailed ||
        state.state == LawYearLoadUiState.loading)) return;

    if (!state.hasMore) return;

    emit(state.copyWith(state: LawYearLoadUiState.loadMore));

    try {
      final rawLawYears =
          await _lawYearRepository.get(_lawId, _kPageSize, _page + 1);
      final hasMore = rawLawYears.length != 0;
      var lawYears = _rawDataMapper(rawLawYears);
      if (hasMore) {
        lawYears.add(createLoadMore());
      }

      var currentLawYear = state.lawYears.where(
          (lawYear) => lawYear.type != LawYearListDataPresenterType.loadMore);

      _page += 1;
      emit(
        state.copyWith(
          state: LawYearLoadUiState.loadSuccess,
          lawYears: [...currentLawYear, ...lawYears],
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
