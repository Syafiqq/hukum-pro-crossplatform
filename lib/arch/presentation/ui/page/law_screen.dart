import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/presentation/ui/menu/law_menu_navigation_drawer.dart';
import 'package:hukum_pro/arch/presentation/ui/view/law_menu_navigation_view.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';

class LawScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return KiwiObjectResolver.getInstance().getLoadLawMenuCubit()..load();
      },
      child: Scaffold(
        body: Container(),
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
      ),
    );
  }
}
