import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';

abstract class VersionLocalDatasource {
  Future<List<LawMenuOrderEntity>> getMenus();

  Future<void> setMenus(List<LawMenuOrderEntity> menus);
}
