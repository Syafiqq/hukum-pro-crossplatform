import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';

class SelectedLawMenuCubit extends Cubit<LawMenuOrderEntity?> {
  SelectedLawMenuCubit() : super(null);

  void changeLaw(LawMenuOrderEntity law) {
    emit(law);
  }

  void changeLawIfNotPresent(LawMenuOrderEntity law) {
    if (state != null) {
      return;
    }
    emit(law);
  }
}
