import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/presentation/entity/law_menu_order_data_presenter.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_menu_navigation_state.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LawMenuNavigationView extends StatelessWidget {
  LawMenuNavigationView() : super();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadLawMenuCubit, LawMenuNavigationUiState>(
      builder: (context, state) {
        return state.maybeWhen(
          loadSuccess: (menus, _) {
            return buildMenus(context, menus);
          },
          orElse: () => buildSpinner(context),
        );
      },
    );
  }

  Widget buildMenus(
    BuildContext context,
    List<LawMenuOrderDataPresenter> menus,
  ) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: menus.length,
      itemBuilder: (BuildContext context, int index) {
        switch (menus[index].type) {
          case LawMenuOrderDataPresenterType.header:
            return buildHeader(context);
          case LawMenuOrderDataPresenterType.search:
            return buildSearch(context, menus[index]);
          case LawMenuOrderDataPresenterType.law:
            return buildMenu(context, menus[index]);
          case LawMenuOrderDataPresenterType.sync:
            return buildSync(context, menus[index]);
          case LawMenuOrderDataPresenterType.divider:
            return const Divider(height: 1, thickness: 1);
        }
      },
    );
  }

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
              image: const AssetImage(
                'res/images/ic_hukum_pro_logo_2_48.png',
              ),
              color: AppColor.textOnLightPrimary,
              width: 36,
              height: 36,
            ),
            const SizedBox(width: 4),
            Text(
              'Hukum Pro',
              textAlign: TextAlign.center,
              style: AppFontTitle.extraBold.font(
                24,
                color: AppColor.textOnLightPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearch(BuildContext context, LawMenuOrderDataPresenter menu) {
    return ListTile(
      leading: Icon(Icons.search),
      title: Text(
        menu.name.toUpperCase(),
        style: AppFontContent.regular.font(16),
      ),
      selected: menu.isSelected,
      onTap: () {
        Navigator.pop(context);
        BlocProvider.of<LoadLawMenuCubit>(context).selectMenu(ofId: menu.id);
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
            colors: [Colors.black],
          ),
        ),
      ),
    );
  }

  Widget buildSync(BuildContext context, LawMenuOrderDataPresenter menu) {
    return ListTile(
      leading: Icon(Icons.search),
      title: Text(
        menu.name.toUpperCase(),
        style: AppFontContent.regular.font(16),
      ),
      selected: menu.isSelected,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget buildMenu(BuildContext context, LawMenuOrderDataPresenter menu) {
    return ListTile(
      leading: Icon(Icons.local_police_outlined),
      title: Text(
        menu.name.toUpperCase(),
        style: AppFontContent.regular.font(16),
      ),
      selected: menu.isSelected,
      onTap: () {
        Navigator.pop(context);
        BlocProvider.of<LoadLawMenuCubit>(context).selectMenu(ofId: menu.id);
      },
    );
  }
}
