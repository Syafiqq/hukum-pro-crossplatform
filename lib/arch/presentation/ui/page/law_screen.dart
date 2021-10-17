import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/service/active_law_service_impl.dart';
import 'package:hukum_pro/arch/presentation/entity/law_menu_order_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/ui/component/dialog/common_dialog.dart';
import 'package:hukum_pro/arch/presentation/ui/page/law_per_year_screen.dart';
import 'package:hukum_pro/arch/presentation/ui/view/law/law_menu_navigation_view.dart';
import 'package:hukum_pro/arch/presentation/ui/view/law/law_year_list_view.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_menu_navigation_state.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/button_cta_type.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';

class LawScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoadLawMenuCubit>(
          lazy: false,
          create: (BuildContext context) {
            return KiwiObjectResolver.getInstance().getLoadLawMenuCubit()
              ..load();
          },
        ),
      ],
      child: _LawScreenStateful(),
    );
  }
}

class _LawScreenStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LawScreenStatefulState();
}

class _LawScreenStatefulState extends State<_LawScreenStateful> {
  var _title = "Hukum Pro";

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoadLawMenuCubit, LawMenuNavigationUiState>(
      listener: (context, state) {
        state.maybeWhen(
          loadFailed: () {
            CommonDialog.show(context,
                    description: 'Failed to load menu',
                    primaryAction: 'Retry',
                    primaryStyle: ButtonCtaType.solid(
                      false,
                      AppColor.secondary,
                      AppColor.textSecondary,
                    ),
                    isClosable: false,
                    dismissOnTouchOutside: false)
                .then(
              (value) => context.read<LoadLawMenuCubit>().load(),
            );
          },
          loadSuccess: (_, selected) {
            if (selected == null) {
            } else if (selected.type == LawMenuOrderDataPresenterType.search) {
              setState(() {
                _title = "Pencarian";
              });
            } else if (selected.type == LawMenuOrderDataPresenterType.law) {
              setState(() {
                _title = selected.name;
              });
            }
            return buildEmptyStateView(context);
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        drawer: SizedBox(
          width: min(
            max(
              256,
              MediaQuery.of(context).size.width * 0.75,
            ),
            320,
          ), // 75% of screen will be occupied
          child: Drawer(
            child: SafeArea(
              child: LawMenuNavigationView(),
            ),
          ),
        ),
        body: BlocBuilder<LoadLawMenuCubit, LawMenuNavigationUiState>(
          builder: (context, state) {
            return state.maybeWhen(
              loadSuccess: (_, selected) {
                if (selected == null) {
                  return buildEmptyStateView(context);
                } else if (selected.type ==
                    LawMenuOrderDataPresenterType.search) {
                  return Container();
                } else if (selected.type == LawMenuOrderDataPresenterType.law) {
                  return LawYearListView(
                    menuId: selected.id,
                    onRequestOpenPerYearPage: (String menuId, int year) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LawPerYearScreen(
                            menuId: menuId,
                            year: year,
                          ),
                        ),
                      );
                    },
                  );
                }
                return buildEmptyStateView(context);
              },
              orElse: () => buildEmptyStateView(context),
            );
          },
        ),
      ),
    );
  }

  Widget buildEmptyStateView(BuildContext context) {
    return Container();
  }
}
