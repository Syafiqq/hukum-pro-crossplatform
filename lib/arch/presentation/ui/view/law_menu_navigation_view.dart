import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/selected_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_menu_navigation_state.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LawMenuNavigationView extends StatelessWidget {
  LawMenuNavigationView() : super();

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        buildHeader(context),
        const Divider(height: 1, thickness: 1),
        buildSearch(context),
        const Divider(height: 1, thickness: 1),
        buildMenu(context),
        const Divider(height: 1, thickness: 1),
        buildSync(context),
        const Divider(height: 1, thickness: 1),
      ],
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

  Widget buildSearch(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.search),
      title: Text(
        'Pencarian',
        style: AppFontContent.regular.font(16),
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
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildSync(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.sync),
      title: Text(
        'Sinkron',
        style: AppFontContent.regular.font(16),
      ),
    );
  }

  Widget buildMenu(BuildContext context) {
    return BlocBuilder<LoadLawMenuCubit, LawMenuNavigationUiState>(
      builder: (context, state) {
        return state.maybeWhen(
          loadSuccess: (menus) {
            return buildLawMenus(context, menus);
          },
          orElse: () => buildSpinner(context),
        );
      },
    );
  }

  Widget buildLawMenus(BuildContext context, List<LawMenuOrderEntity> menus) {
    return Column(
      children: menus
          .map(
            (e) => ListTile(
              leading: Icon(Icons.local_police_outlined),
              title: Text(
                e.name?.toUpperCase() ?? '',
                style: AppFontContent.regular.font(16),
              ),
              onTap: () {
                BlocProvider.of<SelectedLawMenuCubit>(context).changeLaw(e);
                Navigator.pop(context);
              },
            ),
          )
          .toList(),
    );
  }
}
