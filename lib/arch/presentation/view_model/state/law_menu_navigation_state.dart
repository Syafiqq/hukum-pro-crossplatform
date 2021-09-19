import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/presentation/entity/law_menu_order_data_presenter.dart';

part 'law_menu_navigation_state.freezed.dart';

@freezed
class LawMenuNavigationUiState with _$LawMenuNavigationUiState {
  const factory LawMenuNavigationUiState.initial() = InitialState;
  const factory LawMenuNavigationUiState.loading() = MenuLoading;
  const factory LawMenuNavigationUiState.loadSuccess(
      List<LawMenuOrderDataPresenter> menus) = MenuLoadSuccess;
  const factory LawMenuNavigationUiState.loadFailed() = MenuLoadFailed;
}
