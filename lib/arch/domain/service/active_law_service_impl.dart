import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';

import 'active_law_service.dart';

class ActiveLawServiceImpl implements ActiveLawService {
  final LawMenuOrderRepository _lawMenuOrderRepository;

  String? _activeLawId;
  int? _activeYear;
  LawMenuOrderEntity? _activeLawMenuEntity;

  ActiveLawServiceImpl(this._lawMenuOrderRepository);

  @override
  changeLawId({required String to}) {
    if (_activeLawId == to) {
      return;
    }

    _activeLawId = to;
    _activeYear = null;
    _activeLawMenuEntity = null;
  }

  @override
  String? getActiveLawId() => _activeLawId;

  @override
  Future<LawMenuOrderEntity?> getActiveLawMenu() async {
    var menu = _activeLawMenuEntity;
    if (menu != null) {
      return menu;
    }
    _activeLawMenuEntity = await _lawMenuOrderRepository
        .fetchFromLocal()
        .then((menus) => menus.firstWhere((menu) => menu.id == _activeLawId));
    return _activeLawMenuEntity;
  }

  @override
  int? getActiveYear() => _activeYear;
}
