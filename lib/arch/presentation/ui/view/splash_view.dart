import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hukum_pro/arch/presentation/ui/component/dialog/common_dialog.dart';
import 'package:hukum_pro/arch/presentation/view_model/cubit/initialize_app_cubit.dart';
import 'package:hukum_pro/arch/presentation/view_model/state/initialize_app_state.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:hukum_pro/common/ui/button_cta_type.dart';
import 'package:hukum_pro/di/impl/kiwi_object_resolver.dart';

class SplashView extends StatelessWidget {
  late final Function? _onInitializeSuccess;

  SplashView({Key? key, required Function? onInitializeSuccess})
      : super(key: key) {
    this._onInitializeSuccess = onInitializeSuccess;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KiwiObjectResolver.getInstance()
          .getInitializeAppCubit()
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
                color: AppColor.textOnLightPrimary,
                width: 128,
                height: 128,
              ),
            ),
          ),
          Text(
            'Hukum Pro',
            style: AppFontTitle.extraBold.font(
              28,
              color: AppColor.textOnLightPrimary,
            ),
          ),
          Container(
            height: 36,
            child: BlocConsumer<InitializeAppCubit,
                InitializeAppState>(
              listener: (context, state) {
                state.maybeWhen(
                  versionPresent: (_) {
                    _onInitializeSuccess?.call(context);
                  },
                  checkVersionFailed: () {
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
                      (value) => context
                          .read<InitializeAppCubit>()
                          .checkVersion(),
                    );
                  },
                  initializeAppFailed: (version) {
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
                          .read<InitializeAppCubit>()
                          .initializeApp(version),
                    );
                  },
                  initializeAppSuccess: () {
                    _onInitializeSuccess?.call(context);
                  },
                  orElse: () {},
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  versionLoading: () => buildProgress(context, 'Check Version'),
                  checkVersionFailed: () =>
                      buildProgress(context, 'Check Failed'),
                  versionPresent: (_) =>
                      buildProgress(context, 'Check Success'),
                  versionNotExistButRemote: (_) =>
                      buildProgress(context, 'App not initialized'),
                  initializeAppLoading: () =>
                      buildProgress(context, 'Initialize App'),
                  initializeAppFailed: (_) =>
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
          style: AppFontSubtitle.semiBold.font(
            10,
            color: AppColor.textOnLightPrimary,
          ),
        ),
      ],
    );
  }
}
