import 'package:flutter/material.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/presentation/ui/view/law/law_per_year_list_view.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';
import 'package:loading_indicator/loading_indicator.dart';
//
//
class LawPerYearScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _LawPerYearScreenStateful();
  }
}

class _LawPerYearScreenStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LawPerYearScreenStatefulState();
}

class _LawPerYearScreenStatefulState extends State<_LawPerYearScreenStateful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<LawMenuOrderEntity?>(
          future: KiwiObjectResolver.getInstance()
              .getActiveLawService()
              .getActiveLawMenu(), // a previously-obtained Future<String> or null
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
