import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/entity/version/check_local_version_state.dart';
import 'package:hukum_pro/arch/domain/use_case/check_version_first_time_use_case.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/arch/presentation/ui/component/dialog/common_dialog.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/check_local_version_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/splash_view_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/check_local_version_ui_state.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/splash_view_ui_state.dart';
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
            child: BlocConsumer<SplashViewCubit, SplashViewUiState>(
              listener: (context, state) {
                state.maybeWhen(
                  checkVersionFailed: (_) {
                    CommonDialog.show(context,
                            description: 'Failed to check version',
                            primaryAction: 'Retry',
                            primaryStyle: ButtonCtaType.solid(
                              false,
                              AppColor.secondary,
                              AppColor.textSecondary,
                            ),
                            isClosable: false,
                            dismissOnTouchOutside: false)
                        .then(
                      (value) => context.read<SplashViewCubit>().checkVersion(),
                    );
                  },
                  initializeAppFailed: (_, version) {
                    CommonDialog.show(context,
                            description: 'Failed to initialize app',
                            primaryAction: 'Retry',
                            primaryStyle: ButtonCtaType.solid(
                              false,
                              AppColor.secondary,
                              AppColor.textSecondary,
                            ),
                            isClosable: false,
                            dismissOnTouchOutside: false)
                        .then(
                      (value) => context
                          .read<SplashViewCubit>()
                          .initializeApp(version),
                    );
                  },
                  orElse: () {},
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  versionLoading: () => buildProgress(context, 'Check Version'),
                  checkVersionFailed: (_) =>
                      buildProgress(context, 'Check Failed'),
                  checkVersionSuccess: (_) =>
                      buildProgress(context, 'Check Success'),
                  initializeAppLoading: () =>
                      buildProgress(context, 'Initialize App'),
                  initializeAppFailed: (_, __) =>
                      buildProgress(context, 'Initialize Failed'),
                  initializeAppSuccess: () =>
                      buildProgress(context, 'Initialize Success'),
                  orElse: () => SizedBox.shrink(),
                );
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
