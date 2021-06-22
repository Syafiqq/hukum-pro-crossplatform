import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';

abstract class LawMenuOrderRepository {
  Future<List<LawMenuOrderEntity>> fetchFromServer();
  Future<List<LawMenuOrderEntity>> fetchFromLocal();
  Future<void> save(List<LawMenuOrderEntity> menus);
}
