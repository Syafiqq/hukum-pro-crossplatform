import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LawMenuNavigationView extends StatelessWidget {
  final int _selectedDestination = 0;

  LawMenuNavigationView() : super();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          KiwiObjectResolver.getInstance().getLoadLawMenuCubit()..load(),
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
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
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: Text(
                'Pencarian',
                style: AppFontContent.regular.font(16),
              ),
              onTap: () => selectDestination(0),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            Padding(
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
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(Icons.sync),
              title: Text(
                'Sinkron',
                style: AppFontContent.regular.font(16),
              ),
              onTap: () => selectDestination(0),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  void selectDestination(int index) {
    print('Select destination $index');
  }
}
