import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';

abstract class LawMenuOrderRemoteDatasource {
  Future<List<LawMenuOrderEntity>> getMenus();
}
