import 'package:flutter/material.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:hukum_pro/common/ui/button_cta_type.dart';
import 'package:hukum_pro/common/ui/dialog_closing_state.dart';

const _kDefaultStyle = ButtonCtaType.outline(
    false, AppColor.background, AppColor.textOnLightPrimary);

class CommonDialog extends StatelessWidget {
  final bool? closable;
  final String? title;
  final String? description;
  final String? primaryAction;
  final ButtonCtaType primaryStyle;
  final String? secondaryAction;
  final ButtonCtaType secondaryStyle;

  CommonDialog({
    this.closable,
    this.title,
    this.description,
    this.primaryAction,
    this.primaryStyle = _kDefaultStyle,
    this.secondaryAction,
    this.secondaryStyle = _kDefaultStyle,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 24,
      backgroundColor: AppColor.background,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 24),
            child: Container(
              color: Colors.transparent,
              child: createDialogContent(context),
            ),
          ),
          createCloseContent(context),
        ],
      ),
    );
  }

  Widget createDialogContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        this.title != null
            ? Center(
                child: Text(
                  this.title ?? '',
                  style: AppFontTitle.bold.font(
                    18,
                    AppColor.textOnLightPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : SizedBox.shrink(),
        this.description != null && this.title != null
            ? SizedBox(height: 16)
            : SizedBox.shrink(),
        this.description != null
            ? Center(
                child: Text(
                  this.description ?? '',
                  style: AppFontContent.medium.font(
                    14,
                    AppColor.textOnLightPrimary,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : SizedBox.shrink(),
        this.primaryAction != null &&
                (this.title != null || this.description != null)
            ? SizedBox(height: 24)
            : SizedBox.shrink(),
        this.primaryAction != null
            ? generateButtonWidget(
                context,
                primaryAction ?? '',
                primaryStyle,
                DialogClosingState.primary,
              )
            : SizedBox.shrink(),
        this.secondaryAction != null
            ? this.primaryAction != null
                ? SizedBox(height: 8)
                : (this.title != null || this.description != null)
                    ? SizedBox(height: 24)
                    : SizedBox.shrink()
            : SizedBox.shrink(),
        this.secondaryAction != null
            ? generateButtonWidget(
                context,
                secondaryAction ?? '',
                secondaryStyle,
                DialogClosingState.secondary,
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget createCloseContent(BuildContext context) {
    if (this.closable ?? false) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            color: AppColor.secondary,
            onPressed: () => routeClose(context, DialogClosingState.close),
          )
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget generateButtonWidget(
    BuildContext context,
    String text,
    ButtonCtaType style,
    DialogClosingState state,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 196,
          maxWidth: 256,
        ),
        child: TextButton(
          child: Text(
            text.toUpperCase(),
            style: AppFontTitle.bold.font(
              14,
              null,
            ),
          ),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.fromLTRB(16, 12, 16, 12),
            ),
            foregroundColor: MaterialStateProperty.all(style.foregroundColor),
            backgroundColor: MaterialStateProperty.all(style.backgroundColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: style is ButtonCtaTypeOutline
                    ? BorderSide(
                        width: 1.5,
                        color: style.foregroundColor,
                      )
                    : BorderSide.none,
              ),
            ),
          ),
          onPressed: () => routeClose(context, state),
        ),
      ),
    );
  }

  void routeClose(BuildContext context, DialogClosingState state) {
    Navigator.of(context, rootNavigator: true).pop(state);
  }

  static Future<DialogClosingState?> show(
    BuildContext context, {
    String? title,
    String? description,
    String? primaryAction,
    ButtonCtaType primaryStyle = _kDefaultStyle,
    String? secondaryAction,
    ButtonCtaType secondaryStyle = _kDefaultStyle,
    bool isClosable = false,
    bool dismissOnTouchOutside = true,
  }) =>
      showDialog(
          context: context,
          barrierDismissible: dismissOnTouchOutside,
          builder: (BuildContext context) {
            return CommonDialog(
              closable: isClosable,
              title: title,
              description: description,
              primaryAction: primaryAction,
              primaryStyle: primaryStyle,
              secondaryAction: secondaryAction,
              secondaryStyle: secondaryStyle,
            );
          });
}
