import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_year_load_state.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
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
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: BlocConsumer<LoadLawYearCubit, LawYearLoadState>(
            listener: (context, state) {
              // TODO: Show Failed dialog
            },
            builder: (context, state) {
              switch (state.state) {
                case LawYearLoadUiState.loading:
                  return buildSpinner(context);
                case LawYearLoadUiState.loadSuccess:
                  return ListView.separated(
                    itemCount: state.lawYears.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Center(
                          child: Text(
                            'Entry ${state.lawYears[index].year}',
                            style: AppFontContent.regular.font(14),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
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
            colors: [AppColor.secondary],
          ),
        ),
      ),
    );
  }
}
