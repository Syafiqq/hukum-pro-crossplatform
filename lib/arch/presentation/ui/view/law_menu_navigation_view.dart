import 'package:flutter/material.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LawMenuNavigationView extends StatelessWidget {
  final int _selectedDestination = 0;

  LawMenuNavigationView() : super();

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                      AppColor.textOnLightPrimary,
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
            leading: Icon(Icons.favorite),
            title: Text('Item 1'),
            selected: _selectedDestination == 0,
            onTap: () => selectDestination(0),
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Item 2'),
            selected: _selectedDestination == 1,
            onTap: () => selectDestination(1),
          ),
          ListTile(
            leading: Icon(Icons.label),
            title: Text('Item 3'),
            selected: _selectedDestination == 2,
            onTap: () => selectDestination(2),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Label',
            ),
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Item A'),
            selected: _selectedDestination == 3,
            onTap: () => selectDestination(3),
          ),
        ],
      ),
    );
  }

  void selectDestination(int index) {
    print('Select destination $index');
  }
}
