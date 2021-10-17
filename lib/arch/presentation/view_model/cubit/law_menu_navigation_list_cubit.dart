import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/presentation/entity/law_menu_order_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_menu_navigation_list_state.dart';
import 'package:flinq/flinq.dart';

class LawMenuNavigationListCubit extends Cubit<LawMenuNavigationListState> {
  final LawMenuOrderRepository _lawMenuOrderRepository;
  var _startingStaticId = 1000;

  LawMenuOrderEntity? _activeMenu;

  LawMenuOrderEntity? get activeMenu => _activeMenu;

  late List<LawMenuOrderEntity> _rawLaws;

  LawMenuNavigationListCubit(
    this._lawMenuOrderRepository,
  ) : super(LawMenuNavigationListState.initial());

  Future<void> load() async {
    if (!(state is InitialState || state is MenuLoadFailed)) return;

    emit(LawMenuNavigationListState.loading());

    try {
      var rawLaws = await _lawMenuOrderRepository.fetchFromLocal();
      rawLaws.sort((a, b) => (a.order ?? 0) - (b.order ?? 0));
      this._rawLaws = rawLaws;

      List<LawMenuOrderDataPresenter> menus = [];

      menus.addAll([
        LawMenuOrderDataPresenter(
          "${++_startingStaticId}",
          LawMenuOrderDataPresenterType.header,
          "",
          false,
        ),
        LawMenuOrderDataPresenter(
          "${++_startingStaticId}",
          LawMenuOrderDataPresenterType.divider,
          "",
          false,
        ),
        LawMenuOrderDataPresenter(
          "${++_startingStaticId}",
          LawMenuOrderDataPresenterType.search,
          "Pencarian",
          false,
        ),
        LawMenuOrderDataPresenter(
          "${++_startingStaticId}",
          LawMenuOrderDataPresenterType.divider,
          "",
          false,
        )
      ]);
      menus.addAll(_rawDataMapper(rawLaws));
      menus.addAll([
        LawMenuOrderDataPresenter(
          "${++_startingStaticId}",
          LawMenuOrderDataPresenterType.divider,
          "",
          false,
        ),
        LawMenuOrderDataPresenter(
          "${++_startingStaticId}",
          LawMenuOrderDataPresenterType.sync,
          "Sinkron",
          false,
        ),
        LawMenuOrderDataPresenter(
          "${++_startingStaticId}",
          LawMenuOrderDataPresenterType.divider,
          "",
          false,
        ),
      ]);

      if (menus.where((menu) => menu.isSelected).isEmpty) {
        var index = -1;

        final savedLawId = _activeMenu?.id;
        if (savedLawId != null) {
          index = menus.indexWhere((menu) => menu.id == savedLawId);
        }

        if (index < 0) {
          index = menus.indexWhere(
              (menu) => menu.type == LawMenuOrderDataPresenterType.law);
        }

        if (index >= 0) {
          menus[index].isSelected = true;
          _activeMenu =
              _rawLaws.firstOrNullWhere((law) => law.id == menus[index].id);
        }
      }

      emit(LawMenuNavigationListState.loadSuccess(
        menus,
        menus.firstOrNullWhere((menu) => menu.isSelected),
      ));
    } on Exception catch (e) {
      print(e);
      emit(LawMenuNavigationListState.loadFailed());
    }
  }

  void selectMenu({of: LawMenuOrderDataPresenter}) async {
    if (!(state is MenuLoadSuccess)) return;
    var menus = (state as MenuLoadSuccess).menus;

    final index = menus.indexWhere((menu) => menu.id == of.id);

    if (index < 0) {
      return;
    }

    menus.forEach((menu) {
      menu.isSelected = false;
    });
    menus[index].isSelected = true;
    _activeMenu = _rawLaws.firstOrNullWhere((law) => law.id == menus[index].id);

    emit(LawMenuNavigationListState.loadSuccess(
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
