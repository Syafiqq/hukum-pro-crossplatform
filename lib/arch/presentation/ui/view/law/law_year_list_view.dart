import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_year_load_state.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';

class LawYearListView extends StatelessWidget {
  final String lawId;

  LawYearListView(this.lawId) : super();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return KiwiObjectResolver.getInstance().getLoadLawYearCubit()
          ..resetAndLoad(lawId);
      },
      child: BlocBuilder<LoadLawYearCubit, LawYearLoadState>(
        builder: (context, state) {
          switch (state.state) {
            case LawYearLoadUiState.loading:
              return buildSpinner(context);
            default:
              return Container();
          }
        },
      ),
    );
  }

  Widget buildSpinner(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: SizedBox(
          height: 32,
          width: 32,
          child: LoadingIndicator(
            indicatorType: Indicator.circleStrokeSpin,
            colors: [Colors.black],
          ),
        ),
      ),
    );
  }
}
