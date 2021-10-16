import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';

abstract class ActiveLawService {
  Future<LawYearEntity?> getActiveLawYear();

  setActiveLawYear({required int ofId});
}
