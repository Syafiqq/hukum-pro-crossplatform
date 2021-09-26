import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/service/active_law_service.dart';
import 'package:hukum_pro/arch/presentation/entity/law_menu_order_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_menu_navigation_state.dart';
import 'package:flinq/flinq.dart';

class LoadLawMenuCubit extends Cubit<LawMenuNavigationUiState> {
  final LawMenuOrderRepository _lawMenuOrderRepository;
  final ActiveLawService _activeLawService;

  LoadLawMenuCubit(
    this._lawMenuOrderRepository,
    this._activeLawService,
  ) : super(LawMenuNavigationUiState.initial());

  Future<void> load() async {
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

      if (menus.where((menu) => menu.isSelected).isEmpty) {
        var index = -1;

        final savedLawId = _activeLawService.getActiveLawId();
        if (savedLawId != null) {
          index = menus.indexWhere((menu) => menu.id == savedLawId);
        }

        if (index < 0) {
          index = menus.indexWhere(
              (menu) => menu.type == LawMenuOrderDataPresenterType.law);
        }

        if (index >= 0) {
          menus[index].isSelected = true;
          _activeLawService.changeLawId(to: menus[index].id);
        }
      }

      emit(LawMenuNavigationUiState.loadSuccess(
        menus,
        menus.firstOrNullWhere((menu) => menu.isSelected),
      ));
    } on Exception catch (e) {
      print(e);
      emit(LawMenuNavigationUiState.loadFailed());
    }
  }

  void selectMenu({ofId: String}) {
    if (!(state is MenuLoadSuccess)) return;
    var menus = (state as MenuLoadSuccess).menus;

    final index = menus.indexWhere((menu) => menu.id == ofId);

    if (index < 0) {
      return;
    }

    menus.forEach((menu) {
      menu.isSelected = false;
    });
    menus[index].isSelected = true;
    _activeLawService.changeLawId(to: menus[index].id);

    emit(LawMenuNavigationUiState.loadSuccess(
      menus,
      menus.firstOrNullWhere((menu) => menu.isSelected),
    ));
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
