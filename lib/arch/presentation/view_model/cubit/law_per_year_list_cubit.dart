import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/presentation/entity/law_per_year_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/state/load_more_data_fetcher_state.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_per_year_list_state.dart';
import 'package:flinq/flinq.dart';

var _kPageSize = 20;

class LawPerYearListCubit extends Cubit<LawPerYearListLoadState> {
  final LawRepository _lawYearRepository;
  final LawMenuOrderRepository _lawMenuOrderRepository;

  var _startingStaticId = 1000;
  int _page = 0;
  late String _menuId;
  int _lawYear = 0;

  LawPerYearListCubit(this._lawYearRepository, this._lawMenuOrderRepository)
      : super(
          LawPerYearListLoadState(
            state: LoadMoreDataFetcherState.initial,
            laws: List.empty(
              growable: true,
            ),
            hasMore: true,
          ),
        );

  void reset({required String menuId, required int year}) {
    if (![
      LoadMoreDataFetcherState.initial,
      LoadMoreDataFetcherState.loadSuccess,
      LoadMoreDataFetcherState.loadFailed,
      LoadMoreDataFetcherState.reset,
    ].contains(state.state)) {
      return;
    }

    _page = 0;
    _menuId = menuId;
    _lawYear = year;
    emit(
      state.copyWith(
        state: LoadMoreDataFetcherState.reset,
        laws: [],
        hasMore: true,
      ),
    );
  }

  Future<void> resetAndLoad({required String menuId, required int year}) async {
    if (![
      LoadMoreDataFetcherState.initial,
      LoadMoreDataFetcherState.loadSuccess,
      LoadMoreDataFetcherState.loadFailed,
      LoadMoreDataFetcherState.reset,
    ].contains(state.state)) {
      return;
    }

    reset(menuId: menuId, year: year);
    emit(state.copyWith(state: LoadMoreDataFetcherState.loading));

    try {
      final rawLawPerYears = await _lawYearRepository.getByYear(
        _menuId,
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
          state: LoadMoreDataFetcherState.loadSuccess,
          laws: [...state.laws, ...laws],
          hasMore: hasMore,
        ),
      );
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(state: LoadMoreDataFetcherState.loadFailed));
    }
  }

  Future<void> loadMore() async {
    if (![
      LoadMoreDataFetcherState.loadSuccess,
      LoadMoreDataFetcherState.loadFailed,
    ].contains(state.state)) {
      return;
    }

    if (!state.hasMore) return;

    emit(state.copyWith(state: LoadMoreDataFetcherState.loadMore));

    try {
      final rawLawPerYears = await _lawYearRepository.getByYear(
        _menuId,
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
          state: LoadMoreDataFetcherState.loadSuccess,
          laws: [...currentLawPerYear, ...laws],
          hasMore: hasMore,
        ),
      );
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(state: LoadMoreDataFetcherState.loadFailed));
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
        id: "${++_startingStaticId}",
        type: LawPerYearDataPresenterType.loadMore,
        name: "");
  }

  Future<LawMenuOrderEntity?> getCurrentMenu() async {
    final menus = await _lawMenuOrderRepository.fetchFromLocal();
    return menus.firstOrNullWhere((menu) => menu.id == _menuId);
  }
}
