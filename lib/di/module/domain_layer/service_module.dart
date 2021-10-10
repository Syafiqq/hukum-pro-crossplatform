import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/arch/domain/service/active_law_service.dart';
import 'package:hukum_pro/arch/domain/service/active_law_service_impl.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case_impl.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case_impl.dart';
import 'package:kiwi/kiwi.dart';

class ServiceModule {
  static final ServiceModule _singleton = ServiceModule._internal();

  factory ServiceModule() {
    return _singleton;
  }

  ServiceModule._internal();

  void build() {
    final KiwiContainer container = KiwiContainer();

    container.registerSingleton<ActiveLawService>(
      (c) => ActiveLawServiceImpl(
        c<LawMenuOrderRepository>(),
        c<LawYearRepository>(),
      ),
    );
  }
}
