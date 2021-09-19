import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/presentation/entity/law_menu_order_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/ui/component/dialog/common_dialog.dart';
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
              ..load(initializeSelect: true);
          },
        ),
      ],
      child: BlocListener<LoadLawMenuCubit, LawMenuNavigationUiState>(
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
            orElse: () {},
          );
        },
        child: Scaffold(
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
                  }
                  if (selected.type == LawMenuOrderDataPresenterType.search) {
                    return Container();
                  }
                  if (selected.type == LawMenuOrderDataPresenterType.law) {
                    return LawYearListView(selected.id);
                  }
                  return buildEmptyStateView(context);
                },
                orElse: () => buildEmptyStateView(context),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildEmptyStateView(BuildContext context) {
    return Container();
  }
}
