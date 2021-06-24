import 'package:hukum_pro/arch/data/data_source/local/contract/law_menu_order_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/law_menu_order_remote_datasource.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';

class LawMenuOrderRepositoryImpl implements LawMenuOrderRepository {
  LawMenuOrderRemoteDatasource remoteDatasource;
  LawMenuOrderLocalDatasource localDatasource;

  LawMenuOrderRepositoryImpl(this.remoteDatasource, this.localDatasource);

  @override
  Future<List<LawMenuOrderEntity>> fetchFromLocal() async =>
      localDatasource.getMenusOrEmpty();

  @override
  Future<List<LawMenuOrderEntity>> fetchFromRemote() async =>
      remoteDatasource.getMenus();

  @override
  Future<void> saveToLocal(List<LawMenuOrderEntity> menus) async =>
      localDatasource.setMenus(menus);
}
