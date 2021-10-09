import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/service/active_law_service.dart';
import 'package:hukum_pro/arch/presentation/entity/law_per_year_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_per_year_load_state.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_year_load_state.dart';

var _kPageSize = 20;

class LoadLawPerYearCubit extends Cubit<LawPerYearLoadState> {
  final LawRepository _lawYearRepository;
  final ActiveLawService _activeLawService;

  var startingStaticId = 1000;
  int _page = 0;
  String _lawId = "";
  int _lawYear = 0;

  LoadLawPerYearCubit(
    this._lawYearRepository,
    this._activeLawService,
  ) : super(
          LawPerYearLoadState(
            state: LawYearLoadUiState.initial,
            laws: List.empty(
              growable: true,
            ),
            hasMore: true,
          ),
        );

  Future<void> resetAndLoad() async {
    if (!(state.state == LawYearLoadUiState.initial ||
        state.state == LawYearLoadUiState.loading)) return;

    final lawId = _activeLawService.getActiveLawId();
    final lawYear = _activeLawService.getActiveYear();
    if (lawId == null || lawYear == null) {
      return;
    }

    _page = 0;
    _lawId = lawId;
    _lawYear = lawYear;
    emit(
      state.copyWith(
        state: LawYearLoadUiState.reset,
        laws: [],
        hasMore: true,
      ),
    );
    emit(state.copyWith(state: LawYearLoadUiState.loading));

    try {
      final rawLawPerYears = await _lawYearRepository.getByYear(
        _lawId,
        _lawYear,
        _kPageSize,
        _page,
      );
      final hasMore = rawLawPerYears.length == _kPageSize;
      var laws = _rawDataMapper(rawLawPerYears);
      if (hasMore) {
        laws.add(createLoadMore());
      }

      emit(
        state.copyWith(
          state: LawYearLoadUiState.loadSuccess,
          laws: [...state.laws, ...laws],
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
      final rawLawPerYears = await _lawYearRepository.getByYear(
        _lawId,
        _lawYear,
        _kPageSize,
        _page + 1,
      );
      final hasMore = rawLawPerYears.length != 0;
      var laws = _rawDataMapper(rawLawPerYears);
      if (hasMore) {
        laws.add(createLoadMore());
      }

      var currentLawPerYear = state.laws.where(
          (lawYear) => lawYear.type != LawPerYearDataPresenterType.loadMore);

      _page += 1;
      emit(
        state.copyWith(
          state: LawYearLoadUiState.loadSuccess,
          laws: [...currentLawPerYear, ...laws],
          hasMore: hasMore,
        ),
      );
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(state: LawYearLoadUiState.loadFailed));
    }
  }

  List<LawPerYearDataPresenter> _rawDataMapper(List<LawEntity> laws) {
    return laws
        .map(
          (law) => LawPerYearDataPresenter(
            id: "${law.id}",
            type: LawPerYearDataPresenterType.law,
            name: law.no ?? "",
          ),
        )
        .toList();
  }

  LawPerYearDataPresenter createLoadMore() {
    return LawPerYearDataPresenter(
        id: "${++startingStaticId}",
        type: LawPerYearDataPresenterType.loadMore,
        name: "");
  }
}
