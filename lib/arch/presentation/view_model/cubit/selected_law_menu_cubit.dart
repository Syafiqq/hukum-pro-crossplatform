import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';

class SelectedLawMenuCubit extends Cubit<LawMenuOrderEntity?> {
  SelectedLawMenuCubit() : super(null);

  Future<void> changeLaw(LawMenuOrderEntity law) async {
    emit(law);
  }
}
