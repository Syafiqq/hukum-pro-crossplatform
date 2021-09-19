import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';

class LawYearListView extends StatelessWidget {
  final String lawId;

  LawYearListView(this.lawId) : super();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return KiwiObjectResolver.getInstance().getLoadLawYearCubit()
          ..resetAndLoad(lawId);
      },
      child: Container(),
    );
  }
}
