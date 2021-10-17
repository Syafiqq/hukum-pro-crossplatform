import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/presentation/entity/law_menu_order_data_presenter.dart';

part 'law_menu_navigation_list_state.freezed.dart';

@freezed
class LawMenuNavigationListState with _$LawMenuNavigationListState {
  const factory LawMenuNavigationListState.initial() = InitialState;
  const factory LawMenuNavigationListState.loading() = MenuLoading;
  const factory LawMenuNavigationListState.loadSuccess(
    List<LawMenuOrderDataPresenter> menus,
    LawMenuOrderDataPresenter? selected,
  ) = MenuLoadSuccess;
  const factory LawMenuNavigationListState.loadFailed() = MenuLoadFailed;
}
