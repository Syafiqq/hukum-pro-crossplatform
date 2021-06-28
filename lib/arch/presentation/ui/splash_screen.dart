import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/check_local_version_ui_state.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          KiwiObjectResolver.getInstance().getCheckLocalVersionCubit()
            ..checkVersion(),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.lerp(
                          Alignment.topCenter, Alignment.bottomCenter, 0.4) ??
                      Alignment.center,
                  child: Image(
                    image: AssetImage('res/images/ic_hukum_pro_logo_2_192.png'),
                    color: Color(0xFF313131),
                    width: 128,
                    height: 128,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Hukum Pro',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      color: Color(0xFF313131),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 36,
            child:
                BlocBuilder<CheckLocalVersionCubit, CheckLocalVersionUiState>(
              builder: (context, state) {
                switch (state.status) {
                  case CheckLocalVersionUiStatus.initial:
                    return SizedBox.shrink();
                  case CheckLocalVersionUiStatus.loading:
                    return buildProgress(context, 'Check Version');
                  case CheckLocalVersionUiStatus.success:
                    return SizedBox.shrink();
                  case CheckLocalVersionUiStatus.failure:
                    return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProgress(BuildContext context, [String text = '']) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: LinearProgressIndicator(),
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Khula',
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: Color(0xFF313131),
          ),
        ),
      ],
    );
  }
}
