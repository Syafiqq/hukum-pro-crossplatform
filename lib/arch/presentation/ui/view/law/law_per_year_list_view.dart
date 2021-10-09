import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/presentation/entity/law_per_year_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/state/load_more_data_fetcher_state.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_per_year_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_per_year_load_state.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_year_load_state.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';
import 'package:loading_indicator/loading_indicator.dart';
//
//
class LawPerYearListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return KiwiObjectResolver.getInstance().getLoadLawPerYearCubit()
          ..resetAndLoad();
      },
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: _LawPerYearListStatefulView(),
        ),
      ),
    );
  }
}

class _LawPerYearListStatefulView extends StatefulWidget {
  @override
  _LawPerYearListStatefulViewState createState() =>
      _LawPerYearListStatefulViewState();
}

class _LawPerYearListStatefulViewState
    extends State<_LawPerYearListStatefulView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoadLawPerYearCubit, LawPerYearLoadState>(
      listener: (context, state) {
        // TODO: Show Failed dialog
      },
      builder: (context, state) {
        switch (state.state) {
          case LoadMoreDataFetcherState.loading:
            return buildSpinner(context);
          case LoadMoreDataFetcherState.loadSuccess:
          case LoadMoreDataFetcherState.loadMore:
            return ListView.separated(
              itemCount: state.laws.length,
              itemBuilder: (BuildContext context, int index) {
                switch (state.laws[index].type) {
                  case LawPerYearDataPresenterType.law:
                    return ListTile(
                      title: Text(
                        state.laws[index].name.toUpperCase(),
                        style: AppFontContent.regular.font(
                          16,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.chevron_right)],
                      ),
                      onTap: () {
                        // TODO: Move to Law Detail
                      },
                    );
                  case LawPerYearDataPresenterType.loadMore:
                    return Container(
                      padding: EdgeInsets.fromLTRB(16, 8, 10, 8),
                      child: Center(
                        child: Text(
                          'Loading...',
                          style: AppFontContent.regularItalic.font(
                            14,
                            color: AppColor.textOnLightSecondary,
                          ),
                        ),
                      ),
                    );
                }
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 1, thickness: 1),
              controller: _scrollController,
            );
          default:
            return Container();
        }
      },
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

  void _onScroll() {
    if (_isBottom) context.read<LoadLawPerYearCubit>().loadMore();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
