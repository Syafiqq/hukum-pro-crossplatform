import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';

abstract class ActiveLawService {
  Future<LawMenuOrderEntity?> getActiveLawMenu();
  Future<LawYearEntity?> getActiveLawYear();

  setActiveLawMenu({required String ofId});
  setActiveLawYear({required int ofId});
}
