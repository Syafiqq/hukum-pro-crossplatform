import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/version/check_local_version_state.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/presentation/ui/component/dialog/common_dialog.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/check_local_version_ui_state.dart';
import 'package:hukum_pro/common/exception/defined_exception.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:hukum_pro/common/ui/button_cta_type.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          KiwiObjectResolver.getInstance().getCheckLocalVersionCubit()
            ..checkVersion(),
      child: Column(
        children: [
          Expanded(
            child: Align(
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
          ),
          Text(
            'Hukum Pro',
            style: AppFontTitle.extraBold.font(28, Color(0xFF313131)),
          ),
          Container(
            height: 36,
            child:
                BlocConsumer<CheckLocalVersionCubit, CheckLocalVersionUiState>(
              listener: (context, state) {
                switch (state.status) {
                  case CheckLocalVersionUiStatus.failure:
                    CommonDialog.show(context,
                            description: "Failed to initialize app",
                            primaryAction: "Okay",
                            primaryStyle: ButtonCtaType.solid(
                              false,
                              AppColor.secondary,
                              AppColor.textSecondary,
                            ),
                            isClosable: false,
                            dismissOnTouchOutside: false)
                        .then(
                      (value) =>
                          context.read<CheckLocalVersionCubit>().checkVersion(),
                    );
                    break;
                  default:
                    break;
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case CheckLocalVersionUiStatus.initial:
                    return SizedBox.shrink();
                  case CheckLocalVersionUiStatus.loading:
                    return buildProgress(context, 'Check Version');
                  case CheckLocalVersionUiStatus.success:
                    return buildProgress(context, 'Check Success');
                  case CheckLocalVersionUiStatus.failure:
                    return buildProgress(context, 'Check Failed');
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
          style: AppFontSubtitle.semiBold.font(10, AppColor.textOnLightPrimary),
        ),
      ],
    );
  }
}
