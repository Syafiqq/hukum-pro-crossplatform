import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/service/active_law_service.dart';

class LawYearPageTitleCubit extends Cubit<String> {
  final ActiveLawService _activeLawService;

  LawYearPageTitleCubit(this._activeLawService) : super("");

  Future<void> resetAndLoad() async {
    final lawMenu = await _activeLawService.getActiveLawMenu();
    if (lawMenu == null) {
      return;
    }
    emit(lawMenu.name ?? "");
  }
}
