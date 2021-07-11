import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_year_load_state.dart';

var _kPageSize = 20;

class LoadLawYearCubit extends Cubit<LawYearLoadState> {
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
      var lawYears = await _lawYearRepository.get(_kPageSize, _page);
      emit(
        state.copyWith(
          state: LawYearLoadUiState.loadSuccess,
          lawYears: [...state.lawYears, ...lawYears],
          hasMore: lawYears.length == _kPageSize,
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
      var lawYears = await _lawYearRepository.get(_kPageSize, _page + 1);
      _page += 1;
      emit(
        state.copyWith(
          state: LawYearLoadUiState.loadSuccess,
          lawYears: [...state.lawYears, ...lawYears],
          hasMore: lawYears.length == _kPageSize,
        ),
      );
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(state: LawYearLoadUiState.loadFailed));
    }
  }
}
