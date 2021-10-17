import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/presentation/ui/view/law/law_per_year_list_view.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_per_year_cubit.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';
import 'package:loading_indicator/loading_indicator.dart';

//
//
class LawPerYearScreen extends StatefulWidget {
  late final String _menuId;
  late final int _year;

  LawPerYearScreen({
    Key? key,
    required String menuId,
    required int year,
  }) : super(key: key) {
    _menuId = menuId;
    _year = year;
  }

  @override
  State<StatefulWidget> createState() => _LawPerYearScreenState();
}

class _LawPerYearScreenState extends State<LawPerYearScreen> {
  late final LoadLawPerYearCubit lawPerYearCubit;

  @override
  void initState() {
    super.initState();
    lawPerYearCubit = KiwiObjectResolver.getInstance().getLoadLawPerYearCubit();
    lawPerYearCubit.resetAndLoad(menuId: widget._menuId, year: widget._year);
  }

  @override
  void dispose() {
    lawPerYearCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: lawPerYearCubit,
      child: Scaffold(
        appBar: AppBar(
          title: FutureBuilder<LawMenuOrderEntity?>(
            future: Future.value(
                null), // a previously-obtained Future<String> or null
            builder: (
              BuildContext context,
              AsyncSnapshot<LawMenuOrderEntity?> snapshot,
            ) {
              if (snapshot.hasData) {
                return Text(snapshot.data?.name ?? 'Hukum Pro');
              } else if (snapshot.hasError) {
                return Text('HukumPro');
              } else {
                return _buildSpinner(context);
              }
            },
          ),
        ),
        body: LawPerYearListView(),
      ),
    );
  }
}

Widget _buildSpinner(BuildContext context) {
  return Center(
    child: SizedBox(
      height: 24,
      width: 24,
      child: LoadingIndicator(
        indicatorType: Indicator.circleStrokeSpin,
        colors: [AppColor.secondary],
      ),
    ),
  );
}
