import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';

abstract class LawMenuOrderRepository {
  Future<List<LawMenuOrderEntity>> fetchFromRemote();

  Future<List<LawMenuOrderEntity>> fetchFromLocal();

  Future<void> saveToLocal(List<LawMenuOrderEntity> menus);
}
