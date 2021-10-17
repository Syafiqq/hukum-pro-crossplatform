import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/presentation/entity/law_year_list_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/state/load_more_data_fetcher_state.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_year_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_year_load_state.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';
import 'package:loading_indicator/loading_indicator.dart';

//
class LawYearListView extends StatelessWidget {
  late final Function(String, int)? _onRequestOpenPerYearPage;
  late final LoadLawYearCubit _loadLawYearCubit;

  LawYearListView(
      {Key? key,
      required String menuId,
      required Function(String, int)? onRequestOpenPerYearPage})
      : super(key: key) {
    this._onRequestOpenPerYearPage = onRequestOpenPerYearPage;
    this._loadLawYearCubit =
        KiwiObjectResolver.getInstance().getLoadLawYearCubit();
    _loadLawYearCubit.resetAndLoad(menuId: menuId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _loadLawYearCubit,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: _LawYearListStatefulView(
            onItemTapped: _onRequestOpenPerYearPage,
          ),
        ),
      ),
    );
  }
}

class _LawYearListStatefulView extends StatefulWidget {
  late final Function(String, int)? _onItemTapped;

  _LawYearListStatefulView(
      {Key? key, required Function(String, int)? onItemTapped})
      : super(key: key) {
    this._onItemTapped = onItemTapped;
  }

  @override
  _LawYearListStatefulViewState createState() => _LawYearListStatefulViewState(
        onItemTapped: _onItemTapped,
      );
}

class _LawYearListStatefulViewState extends State<_LawYearListStatefulView> {
  final _scrollController = ScrollController();

  late final Function(String, int)? _onItemTapped;

  _LawYearListStatefulViewState({required Function(String, int)? onItemTapped})
      : super() {
    this._onItemTapped = onItemTapped;
  }

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
    return BlocConsumer<LoadLawYearCubit, LawYearLoadState>(
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
              itemCount: state.lawYears.length,
              itemBuilder: (BuildContext context, int index) {
                switch (state.lawYears[index].type) {
                  case LawYearListDataPresenterType.law:
                    return ListTile(
                      title: Text(
                        'Tahun ${state.lawYears[index].year}'.toUpperCase(),
                        style: AppFontContent.regular.font(
                          16,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${state.lawYears[index].count}'.toUpperCase(),
                            style: AppFontContent.medium.font(
                              16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            color: AppColor.secondaryLight,
                          )
                        ],
                      ),
                      onTap: () {
                        final year = state.lawYears[index].id;
                        final menuId =
                            BlocProvider.of<LoadLawYearCubit>(context).menuId;

                        _onItemTapped?.call(menuId, year);
                      },
                    );
                  case LawYearListDataPresenterType.loadMore:
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
    if (_isBottom) context.read<LoadLawYearCubit>().loadMore();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
