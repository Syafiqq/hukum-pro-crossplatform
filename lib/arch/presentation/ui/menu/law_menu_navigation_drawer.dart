import 'package:flutter/material.dart';
import 'package:hukum_pro/arch/presentation/ui/view/law_menu_navigation_view.dart';

class LawMenuNavigationDrawer extends StatelessWidget {
  LawMenuNavigationDrawer() : super();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: LawMenuNavigationView(),
      ),
    );
  }
}
