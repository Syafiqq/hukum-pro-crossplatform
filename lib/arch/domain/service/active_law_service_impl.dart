import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:flinq/flinq.dart';

import 'active_law_service.dart';

class ActiveLawServiceImpl implements ActiveLawService {
  final LawMenuOrderRepository _lawMenuOrderRepository;
  final LawYearRepository _lawYearRepository;

  String? _activeLawMenuId;
  int? _activeLawYearId;
  LawMenuOrderEntity? _activeLawMenuEntity;
  LawYearEntity? _activeLawYearEntity;

  ActiveLawServiceImpl(this._lawMenuOrderRepository, this._lawYearRepository);

  @override
  setActiveLawMenu({required String ofId}) async {
    if (_activeLawMenuId == ofId) {
      return;
    }

    _activeLawMenuId = ofId;
    _activeLawYearId = null;
    _activeLawMenuEntity = null;
    _activeLawYearEntity = null;
    await getActiveLawMenu();
  }

  @override
  setActiveLawYear({required int ofId}) async {
    if (_activeLawYearId == ofId) {
      return;
    }

    _activeLawYearId = ofId;
    await getActiveLawYear();
  }

  @override
  Future<LawMenuOrderEntity?> getActiveLawMenu() async {
    var entity = _activeLawMenuEntity;
    if (entity != null) {
      return entity;
    }
    _activeLawMenuEntity = await _lawMenuOrderRepository.fetchFromLocal().then(
          (menus) =>
              menus.firstOrNullWhere((menu) => menu.id == _activeLawMenuId),
        );
    return _activeLawMenuEntity;
  }

  @override
  Future<LawYearEntity?> getActiveLawYear() async {
    var entity = _activeLawYearEntity;
    if (entity != null) {
      return entity;
    }

    var entityId = _activeLawYearId;
    if (entityId == null) {
      return null;
    }
    _activeLawYearEntity = await _lawYearRepository.getById(entityId);
    return _activeLawYearEntity;
  }
}
