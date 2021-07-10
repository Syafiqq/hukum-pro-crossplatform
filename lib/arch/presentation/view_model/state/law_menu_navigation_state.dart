import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';

part 'law_menu_navigation_state.freezed.dart';

@freezed
class LawMenuNavigationUiState with _$LawMenuNavigationUiState {
  const factory LawMenuNavigationUiState.initial() = InitialState;
  const factory LawMenuNavigationUiState.loading() = MenuLoading;
  const factory LawMenuNavigationUiState.loadSuccess(
      List<LawMenuOrderEntity> menus) = MenuLoadSuccess;
  const factory LawMenuNavigationUiState.loadFailed() = MenuLoadFailed;
}
