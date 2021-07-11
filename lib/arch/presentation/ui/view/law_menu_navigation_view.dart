import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/presentation/ui/component/dialog/common_dialog.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/load_law_menu_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/law_menu_navigation_state.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:hukum_pro/common/ui/button_cta_type.dart';
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
    return BlocConsumer<LoadLawMenuCubit, LawMenuNavigationUiState>(
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
            ),
          )
          .toList(),
    );
  }
}
