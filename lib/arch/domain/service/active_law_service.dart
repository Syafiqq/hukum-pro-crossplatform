import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';

abstract class ActiveLawService {
  String? getActiveLawId();
  int? getActiveYear();
  Future<LawMenuOrderEntity?> getActiveLawMenu();

  changeLawId({required String to});
}
