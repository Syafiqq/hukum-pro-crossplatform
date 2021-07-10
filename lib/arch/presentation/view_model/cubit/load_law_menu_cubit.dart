import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_menu_navigation_state.dart';

class LoadLawMenuCubit extends Cubit<LawMenuNavigationUiState> {
  final LawMenuOrderRepository _lawMenuOrderRepository;

  LoadLawMenuCubit(
    this._lawMenuOrderRepository,
  ) : super(LawMenuNavigationUiState.initial());

  Future<void> load() async {
    if (!(state is InitialState || state is MenuLoadFailed)) return;

    emit(LawMenuNavigationUiState.loading());

    try {
      var menus = await _lawMenuOrderRepository.fetchFromLocal();
      emit(LawMenuNavigationUiState.loadSuccess(menus));
    } on Exception catch (e) {
      print(e);
      emit(LawMenuNavigationUiState.loadFailed());
    }
  }
}
