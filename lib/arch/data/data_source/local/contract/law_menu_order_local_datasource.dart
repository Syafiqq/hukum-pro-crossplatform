import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';

abstract class LawMenuOrderLocalDatasource {
  Future<List<LawMenuOrderEntity>> getMenusOrEmpty();

  Future<void> setMenus(List<LawMenuOrderEntity> menus);
}
