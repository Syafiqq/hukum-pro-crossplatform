import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/presentation/entity/law_menu_order_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_menu_navigation_state.dart';

class LoadLawMenuCubit extends Cubit<LawMenuNavigationUiState> {
  final LawMenuOrderRepository _lawMenuOrderRepository;

  LoadLawMenuCubit(
    this._lawMenuOrderRepository,
  ) : super(LawMenuNavigationUiState.initial());

  Future<void> load({initializeSelect: bool}) async {
    if (!(state is InitialState || state is MenuLoadFailed)) return;

    emit(LawMenuNavigationUiState.loading());

    try {
      var rawLaws = await _lawMenuOrderRepository.fetchFromLocal();
      rawLaws.sort((a, b) => (a.order ?? 0) - (b.order ?? 0));
      var startingStaticId = 1000;

      List<LawMenuOrderDataPresenter> menus = [];

      menus.addAll([
        LawMenuOrderDataPresenter(
          "${++startingStaticId}",
          LawMenuOrderDataPresenterType.header,
          "",
          false,
        ),
        LawMenuOrderDataPresenter(
          "${++startingStaticId}",
          LawMenuOrderDataPresenterType.divider,
          "",
          false,
        ),
        LawMenuOrderDataPresenter(
          "${++startingStaticId}",
          LawMenuOrderDataPresenterType.search,
          "Pencarian",
          false,
        ),
        LawMenuOrderDataPresenter(
          "${++startingStaticId}",
          LawMenuOrderDataPresenterType.divider,
          "",
          false,
        )
      ]);
      menus.addAll(_rawDataMapper(rawLaws));
      menus.addAll([
        LawMenuOrderDataPresenter(
          "${++startingStaticId}",
          LawMenuOrderDataPresenterType.divider,
          "",
          false,
        ),
        LawMenuOrderDataPresenter(
          "${++startingStaticId}",
          LawMenuOrderDataPresenterType.sync,
          "Sinkron",
          false,
        ),
        LawMenuOrderDataPresenter(
          "${++startingStaticId}",
          LawMenuOrderDataPresenterType.divider,
          "",
          false,
        ),
      ]);

      if (initializeSelect &&
          menus.where((element) => element.isSelected).isEmpty) {
        final index = menus.indexWhere(
            (element) => element.type == LawMenuOrderDataPresenterType.law);

        if (index >= 0) {
          menus[index].isSelected = true;
        }
      }

      emit(LawMenuNavigationUiState.loadSuccess(menus));
    } on Exception catch (e) {
      print(e);
      emit(LawMenuNavigationUiState.loadFailed());
    }
  }

  List<LawMenuOrderDataPresenter> _rawDataMapper(
      List<LawMenuOrderEntity> menus) {
    return menus
        .map(
          (menu) => LawMenuOrderDataPresenter(menu.id,
              LawMenuOrderDataPresenterType.law, menu.name ?? "", false),
        )
        .toList(growable: false);
  }
}
